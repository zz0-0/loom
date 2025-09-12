import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/presentation/providers/tab_provider.dart';
import 'package:loom/common/presentation/theme/app_theme.dart';
import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart'
    as domain;
import 'package:loom/features/core/explorer/domain/services/smart_categorization_service.dart';
import 'package:loom/features/core/explorer/presentation/providers/workspace_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Widget that displays collections view
class CollectionsWidget extends ConsumerWidget {
  const CollectionsWidget({
    required this.workspace,
    super.key,
  });

  final domain.Workspace workspace;

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
        return _CollectionItem(
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
      builder: (context) => const _CreateCollectionDialog(),
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

/// Template selection chip widget
class _TemplateChip extends StatelessWidget {
  const _TemplateChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }
}

/// Dialog for creating a new collection with template selection
class _CreateCollectionDialog extends StatefulWidget {
  const _CreateCollectionDialog();

  @override
  State<_CreateCollectionDialog> createState() =>
      _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<_CreateCollectionDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedTemplateId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Collection'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Collection name',
                hintText: 'My Collection',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose a template (optional)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final templates = ref.watch(collectionTemplatesProvider);
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Empty template option
                    _TemplateChip(
                      label: 'Empty',
                      icon: LucideIcons.file,
                      isSelected: _selectedTemplateId == null,
                      onSelected: () {
                        setState(() => _selectedTemplateId = null);
                      },
                    ),
                    // Template options
                    ...templates.map(
                      (template) => _TemplateChip(
                        label: template.name,
                        icon: getIconDataFromString(template.icon),
                        isSelected: _selectedTemplateId == template.id,
                        onSelected: () {
                          setState(() => _selectedTemplateId = template.id);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.of(context).pop({
                'name': _controller.text,
                'templateId': _selectedTemplateId,
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
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
  bool _isDragOver = false;

  void _onFileDroppedFromFileTree(String filePath, BuildContext context) {
    setState(() => _isDragOver = false);

    // Use Riverpod to access the workspace provider
    ProviderScope.containerOf(context)
        .read(currentWorkspaceProvider.notifier)
        .addToCollection(widget.collectionName, filePath);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${path.basename(filePath)} to ${widget.collectionName}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // Show smart suggestions if this collection doesn't match the file well
    _showSmartSuggestionsIfNeeded(filePath, context);
  }

  void _onFileDropped(Map<String, String> dragData, BuildContext context) {
    setState(() => _isDragOver = false);

    final filePath = dragData['filePath']!;
    final sourceCollection = dragData['sourceCollection'];

    // Use Riverpod to access the workspace provider
    final container = ProviderScope.containerOf(context);
    final workspaceNotifier = container.read(currentWorkspaceProvider.notifier);

    if (sourceCollection != null && sourceCollection != widget.collectionName) {
      // Moving between collections
      workspaceNotifier
        ..removeFromCollection(sourceCollection, filePath)
        ..addToCollection(widget.collectionName, filePath);

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Moved ${path.basename(filePath)} to ${widget.collectionName}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Adding from file tree or same collection (shouldn't happen)
      ProviderScope.containerOf(context)
          .read(currentWorkspaceProvider.notifier)
          .addToCollection(widget.collectionName, filePath);

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added ${path.basename(filePath)} to ${widget.collectionName}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Show smart suggestions if this collection doesn't match the file well
    _showSmartSuggestionsIfNeeded(filePath, context);
  }

  void _showSmartSuggestionsIfNeeded(String filePath, BuildContext context) {
    final suggestions =
        SmartCategorizationService.getTopSuggestions(filePath, limit: 2);

    // Check if current collection matches the file well
    final currentTemplate = domain.CollectionTemplates.templates
        .where((t) => t.name == widget.collectionName)
        .firstOrNull;

    var isGoodMatch = true;
    if (currentTemplate != null) {
      isGoodMatch = SmartCategorizationService.fileMatchesTemplate(
        filePath,
        currentTemplate,
      );
    }

    // Show suggestions if there are better matches
    if (!isGoodMatch &&
        suggestions.isNotEmpty &&
        suggestions[0].confidence > 0.7) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          _showSmartSuggestionDialog(filePath, suggestions, context);
        }
      });
    }
  }

  void _showSmartSuggestionDialog(
    String filePath,
    List<CollectionSuggestion> suggestions,
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Smart Suggestion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${path.basename(filePath)} might fit better in:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...suggestions.map(
              (suggestion) => ListTile(
                leading: Icon(
                  getIconDataFromString(suggestion.icon),
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(suggestion.displayName),
                subtitle: Text(suggestion.reason),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(suggestion.confidence * 100).round()}%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _moveToSuggestedCollection(filePath, suggestion, context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Here'),
          ),
        ],
      ),
    );
  }

  void _moveToSuggestedCollection(
    String filePath,
    CollectionSuggestion suggestion,
    BuildContext context,
  ) {
    ProviderScope.containerOf(context).read(currentWorkspaceProvider.notifier)
      ..removeFromCollection(widget.collectionName, filePath)
      ..createCollection(suggestion.displayName)
      ..addToCollection(suggestion.displayName, filePath);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Moved ${path.basename(filePath)} to ${suggestion.displayName}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Collection header with drag target
        DragTarget<Object>(
          onWillAcceptWithDetails: (details) => true,
          onAcceptWithDetails: (details) {
            if (details.data is Map<String, String>) {
              _onFileDropped(details.data as Map<String, String>, context);
            } else if (details.data is String) {
              _onFileDroppedFromFileTree(details.data as String, context);
            }
          },
          onMove: (_) => setState(() => _isDragOver = true),
          onLeave: (_) => setState(() => _isDragOver = false),
          builder: (context, candidateData, rejectedData) {
            return Material(
              color: _isDragOver
                  ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: AppRadius.radiusSm,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: AppRadius.radiusSm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    border: _isDragOver
                        ? Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            width: 2,
                          )
                        : null,
                    borderRadius: AppRadius.radiusSm,
                  ),
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
                        color: _isDragOver
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.collectionName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                _isDragOver ? theme.colorScheme.primary : null,
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
            );
          },
        ),

        // Collection files
        if (_isExpanded && widget.files.isNotEmpty)
          ...widget.files.map(
            (filePath) => _CollectionFileItem(
              filePath: filePath,
              collectionName: widget.collectionName,
              onSelected: () => widget.onFileSelected(filePath),
              onRemove: () => widget.onRemoveFile(filePath),
              onFileMoved: (targetCollection) {
                // This will be handled by the parent widget
                // The actual move logic is in the CollectionsWidget
              },
            ),
          ),

        // Empty collection state
        if (_isExpanded && widget.files.isEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xl,
              right: AppSpacing.sm,
              top: AppSpacing.xs,
              bottom: AppSpacing.xs,
            ),
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
    required this.collectionName,
    required this.onFileMoved,
  });

  final String filePath;
  final VoidCallback onSelected;
  final VoidCallback onRemove;
  final String collectionName;
  final ValueChanged<String>
      onFileMoved; // Called when file is moved to another collection

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName = path.basename(filePath);

    return Draggable<Map<String, String>>(
      data: {
        'filePath': filePath,
        'sourceCollection': collectionName,
      },
      feedback: Material(
        elevation: 4,
        borderRadius: AppRadius.radiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.radiusSm,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getFileIcon(fileName),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildFileItem(context, theme, fileName),
      ),
      child: _buildFileItem(context, theme, fileName),
    );
  }

  Widget _buildFileItem(
    BuildContext context,
    ThemeData theme,
    String fileName,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.sm,
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
          ),
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

/// Utility to convert icon strings to IconData
IconData getIconDataFromString(String? iconName) {
  switch (iconName) {
    case 'code':
      return LucideIcons.code;
    case 'book':
      return LucideIcons.book;
    case 'file-text':
      return LucideIcons.fileText;
    case 'image':
      return LucideIcons.image;
    case 'settings':
      return LucideIcons.settings;
    case 'users':
      return LucideIcons.users;
    case 'briefcase':
      return LucideIcons.briefcase;
    case 'heart':
      return LucideIcons.heart;
    case 'star':
      return LucideIcons.star;
    case 'folder':
      return LucideIcons.folder;
    default:
      return LucideIcons.star;
  }
}
