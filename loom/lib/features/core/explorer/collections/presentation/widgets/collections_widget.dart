import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
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
              'No Collections',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Create collections to organize your files',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _showCreateCollectionDialog(context, ref),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Create Collection'),
            ),
          ],
        ),
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
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "$collectionName"'),
        content: const Text(
          'Are you sure you want to delete this collection? This will not delete the actual files.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
