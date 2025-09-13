import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Individual collection item widget
class CollectionItem extends StatefulWidget {
  const CollectionItem({
    required this.collectionName,
    required this.files,
    required this.onFileSelected,
    required this.onRemoveFile,
    required this.onDeleteCollection,
    super.key,
  });

  final String collectionName;
  final List<String> files;
  final ValueChanged<String> onFileSelected;
  final ValueChanged<String> onRemoveFile;
  final VoidCallback onDeleteCollection;

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
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
        SmartSuggestionService.getTopSuggestions(filePath, limit: 2);

    // Check if current collection matches the file well
    final currentTemplate = CollectionTemplates.templates
        .where((t) => t.name == widget.collectionName)
        .firstOrNull;

    var isGoodMatch = true;
    if (currentTemplate != null) {
      isGoodMatch = SmartSuggestionService.fileMatchesTemplate(
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
            (filePath) => CollectionFileItem(
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
