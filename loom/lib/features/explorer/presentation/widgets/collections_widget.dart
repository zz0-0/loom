import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/models/workspace_settings.dart'
    as models;
import 'package:loom/features/explorer/presentation/providers/workspace_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Widget that displays collections view
class CollectionsWidget extends ConsumerWidget {
  const CollectionsWidget({
    required this.workspace,
    super.key,
  });

  final models.Workspace workspace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections =
        workspace.metadata?.collections ?? <String, List<String>>{};

    if (collections.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final entry = collections.entries.elementAt(index);
        return _CollectionItem(
          collectionName: entry.key,
          files: entry.value,
          onFileSelected: (filePath) {
            // TODO(user): Open file in editor
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
        padding: const EdgeInsets.all(16),
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
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Collection'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Collection name',
            hintText: 'My Collection',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(currentWorkspaceProvider.notifier)
                    .createCollection(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
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

/// Individual collection item widget
class _CollectionItem extends StatefulWidget {
  const _CollectionItem({
    required this.collectionName,
    required this.files,
    required this.onFileSelected,
    required this.onRemoveFile,
    required this.onDeleteCollection,
  });

  final String collectionName;
  final List<String> files;
  final ValueChanged<String> onFileSelected;
  final ValueChanged<String> onRemoveFile;
  final VoidCallback onDeleteCollection;

  @override
  State<_CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<_CollectionItem> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Collection header
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    _isExpanded
                        ? LucideIcons.chevronDown
                        : LucideIcons.chevronRight,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    LucideIcons.star,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.collectionName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.files.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: const Icon(LucideIcons.moreHorizontal, size: 14),
                    iconSize: 14,
                    splashRadius: 12,
                    onSelected: (value) {
                      switch (value) {
                        case 'delete':
                          widget.onDeleteCollection();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(LucideIcons.trash2, size: 14),
                            SizedBox(width: 8),
                            Text('Delete Collection'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Collection files
        if (_isExpanded && widget.files.isNotEmpty)
          ...widget.files.map(
            (filePath) => _CollectionFileItem(
              filePath: filePath,
              onSelected: () => widget.onFileSelected(filePath),
              onRemove: () => widget.onRemoveFile(filePath),
            ),
          ),

        // Empty collection state
        if (_isExpanded && widget.files.isEmpty)
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 8, top: 4, bottom: 4),
            child: Text(
              'No files in this collection',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}

/// Individual file item within a collection
class _CollectionFileItem extends StatelessWidget {
  const _CollectionFileItem({
    required this.filePath,
    required this.onSelected,
    required this.onRemove,
  });

  final String filePath;
  final VoidCallback onSelected;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName = path.basename(filePath);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.only(left: 24, right: 8, top: 4, bottom: 4),
          child: Row(
            children: [
              Icon(
                _getFileIcon(fileName),
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, size: 12),
                onPressed: onRemove,
                splashRadius: 8,
                tooltip: 'Remove from collection',
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.md':
      case '.markdown':
        return LucideIcons.fileText;
      case '.blox':
        return LucideIcons.box;
      case '.txt':
        return LucideIcons.fileText;
      case '.json':
        return LucideIcons.braces;
      case '.yaml':
      case '.yml':
        return LucideIcons.fileCode2;
      case '.dart':
        return LucideIcons.fileCode;
      default:
        return LucideIcons.file;
    }
  }
}
