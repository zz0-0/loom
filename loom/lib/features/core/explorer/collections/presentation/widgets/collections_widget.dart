import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Widget that displays collections view
class CollectionsWidget extends ConsumerWidget {
  const CollectionsWidget({
    required this.workspace,
    super.key,
  });

  final Workspace workspace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections =
        workspace.metadata?.collections ?? <String, List<String>>{};
    final currentFolder = ref.watch(currentFolderProvider);

    // If we have a current folder, show it along with collections
    if (currentFolder != null) {
      return _buildWithCurrentFolder(context, ref, collections, currentFolder);
    }

    if (collections.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return ListView.builder(
      padding: AppSpacing.paddingVerticalXs,
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final entry = collections.entries.elementAt(index);
        return CollectionItem(
          collectionName: entry.key,
          files: entry.value,
          onFileSelected: (filePath) {
            // Open file in editor
            final fileName = path.basename(filePath);
            ref.read(tabProvider.notifier).openTab(
                  id: filePath,
                  title: fileName,
                  contentType: 'file',
                );
          },
          onRemoveFile: (filePath) {
            ref
                .read(currentWorkspaceProvider.notifier)
                .removeFromCollection(entry.key, filePath);
          },
          onDeleteCollection: () {
            _showDeleteCollectionDialog(context, ref, entry.key);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.star,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.noCollections,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              localizations.createCollectionsToOrganize,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _showCreateCollectionDialog(context, ref),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: Text(localizations.createCollection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithCurrentFolder(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<String>> collections,
    Folder currentFolder,
  ) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return ListView(
      padding: AppSpacing.paddingVerticalXs,
      children: [
        // Current folder section
        Padding(
          padding: AppSpacing.paddingHorizontalSm,
          child: Text(
            'Opened Folder: ${path.basename(currentFolder.rootPath)}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildFolderContents(context, ref, currentFolder),
        const SizedBox(height: 16),

        // Collections section
        if (collections.isNotEmpty) ...[
          Padding(
            padding: AppSpacing.paddingHorizontalSm,
            child: Text(
              localizations.collections,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...collections.entries.map((entry) {
            return CollectionItem(
              collectionName: entry.key,
              files: entry.value,
              onFileSelected: (filePath) {
                // Open file in editor
                final fileName = path.basename(filePath);
                ref.read(tabProvider.notifier).openTab(
                      id: filePath,
                      title: fileName,
                      contentType: 'file',
                    );
              },
              onRemoveFile: (filePath) {
                ref
                    .read(currentWorkspaceProvider.notifier)
                    .removeFromCollection(entry.key, filePath);
              },
              onDeleteCollection: () {
                _showDeleteCollectionDialog(context, ref, entry.key);
              },
            );
          }),
        ],
      ],
    );
  }

  Widget _buildFolderContents(
    BuildContext context,
    WidgetRef ref,
    Folder folder,
  ) {
    if (folder.fileTree.isEmpty) {
      return const Padding(
        padding: AppSpacing.paddingMd,
        child: Text('No files in this folder'),
      );
    }

    return Column(
      children: folder.fileTree.map((node) {
        return _buildFileTreeNode(context, ref, node, folder.rootPath);
      }).toList(),
    );
  }

  Widget _buildFileTreeNode(
    BuildContext context,
    WidgetRef ref,
    FileTreeNode node,
    String rootPath,
  ) {
    final theme = Theme.of(context);
    final fullPath = path.join(rootPath, node.path);

    return InkWell(
      onTap: () {
        if (node.type == FileTreeNodeType.file) {
          // Open file in editor
          final fileName = path.basename(fullPath);
          ref.read(tabProvider.notifier).openTab(
                id: fullPath,
                title: fileName,
                contentType: 'file',
              );
        } else {
          // For directories, could expand/collapse, but for now just show
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              node.type == FileTreeNodeType.directory
                  ? LucideIcons.folder
                  : LucideIcons.file,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                node.name,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (node.type == FileTreeNodeType.file)
              IconButton(
                icon: const Icon(LucideIcons.plus, size: 16),
                onPressed: () {
                  // Add file to a collection - for now, show a dialog to choose collection
                  _showAddToCollectionDialog(context, ref, fullPath);
                },
                tooltip: 'Add to collection',
              ),
          ],
        ),
      ),
    );
  }

  void _showAddToCollectionDialog(
    BuildContext context,
    WidgetRef ref,
    String filePath,
  ) {
    final collections =
        workspace.metadata?.collections ?? <String, List<String>>{};

    if (collections.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No collections available. Create a collection first.'),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: collections.keys.map((collectionName) {
            return ListTile(
              title: Text(collectionName),
              onTap: () {
                ref
                    .read(currentWorkspaceProvider.notifier)
                    .addToCollection(collectionName, filePath);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to $collectionName'),
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateCollectionDialog(),
    ).then((result) {
      if (result != null && result['name'] != null) {
        final name = result['name'] as String;
        final templateId = result['templateId'] as String?;

        if (templateId != null) {
          // Create collection from template
          ref
              .read(currentWorkspaceProvider.notifier)
              .createCollectionFromTemplate(name, templateId);
        } else {
          // Create empty collection
          ref.read(currentWorkspaceProvider.notifier).createCollection(name);
        }
      }
    });
  }

  /// Move file from one collection to another
  Future<void> moveFileBetweenCollections(
    String sourceCollection,
    String targetCollection,
    String filePath,
    WidgetRef ref,
  ) async {
    if (sourceCollection == targetCollection) return;

    // Remove from source collection
    await ref
        .read(currentWorkspaceProvider.notifier)
        .removeFromCollection(sourceCollection, filePath);

    // Add to target collection
    await ref
        .read(currentWorkspaceProvider.notifier)
        .addToCollection(targetCollection, filePath);
  }

  void _showDeleteCollectionDialog(
    BuildContext context,
    WidgetRef ref,
    String collectionName,
  ) {
    final localizations = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteCollection(collectionName)),
        content: Text(localizations.deleteCollectionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              // Delete collection by removing all files
              final files =
                  workspace.metadata?.collections[collectionName] ?? [];
              for (final file in files) {
                ref
                    .read(currentWorkspaceProvider.notifier)
                    .removeFromCollection(collectionName, file);
              }
              Navigator.of(context).pop();
            },
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }
}
