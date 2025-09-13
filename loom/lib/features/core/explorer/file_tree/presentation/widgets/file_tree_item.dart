import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Individual file tree item widget
class FileTreeItem extends StatefulWidget {
  const FileTreeItem({
    required this.node,
    required this.depth,
    required this.onToggleExpansion,
    required this.onFileSelected,
    super.key,
  });

  final FileTreeNode node;
  final int depth;
  final ValueChanged<String> onToggleExpansion;
  final ValueChanged<String> onFileSelected;

  @override
  State<FileTreeItem> createState() => _FileTreeItemState();
}

class _FileTreeItemState extends State<FileTreeItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDirectory = widget.node.type == FileTreeNodeType.directory;
    final hasChildren = widget.node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current node
        Material(
          color: Colors.transparent,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onSecondaryTapDown: (details) => _showContextMenu(
                context,
                details.globalPosition,
                widget.node,
              ),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                curve: AppAnimations.scaleCurve,
                padding: EdgeInsets.only(
                  left: AppSpacing.sm + (widget.depth * 16.0),
                  right: AppSpacing.sm,
                  top: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? theme.colorScheme.surfaceContainerHighest
                          .withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: AppRadius.radiusSm,
                ),
                child: InkWell(
                  onTap: () {
                    if (isDirectory) {
                      widget.onToggleExpansion(widget.node.path);
                    } else {
                      widget.onFileSelected(widget.node.path);
                    }
                  },
                  borderRadius: AppRadius.radiusSm,
                  child: Stack(
                    children: [
                      // Indentation guides
                      if (widget.depth > 0)
                        Positioned.fill(
                          child: Row(
                            children: List.generate(widget.depth, (index) {
                              final isLast = index == widget.depth - 1;
                              return Container(
                                width: 16,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 1,
                                  color: theme.dividerColor.withOpacity(0.3),
                                  margin: EdgeInsets.only(
                                    left: isLast ? 8 : 0,
                                    right: isLast ? 8 : 16,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                      // Content
                      Row(
                        children: [
                          // Expansion indicator with rotation animation
                          if (isDirectory)
                            AnimatedRotation(
                              turns: widget.node.isExpanded ? 0.25 : 0.0,
                              duration: AppAnimations.normal,
                              curve: Curves.easeInOut,
                              child: Icon(
                                hasChildren
                                    ? LucideIcons.chevronRight
                                    : LucideIcons.chevronRight,
                                size: 12,
                                color: hasChildren
                                    ? (_isHovered
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant)
                                    : Colors.transparent,
                              ),
                            )
                          else
                            const SizedBox(width: 12),

                          const SizedBox(width: 4),

                          // File/folder icon with hover effect
                          AnimatedScale(
                            scale: _isHovered ? AppAnimations.scaleHover : 1.0,
                            duration: AppAnimations.fast,
                            curve: AppAnimations.scaleCurve,
                            child: Icon(
                              _getIcon(widget.node),
                              size: 14,
                              color: _isHovered
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(width: 6),

                          // File/folder name with hover effect
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: AppAnimations.fast,
                              curve: AppAnimations.scaleCurve,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: _isHovered
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                                fontWeight: _isHovered
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                              child: Text(
                                widget.node.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Children (if expanded) with fade-in animation
        if (isDirectory && widget.node.isExpanded && hasChildren)
          AnimatedOpacity(
            opacity: 1,
            duration: AppAnimations.normal,
            curve: Curves.easeInOut,
            child: Column(
              children: widget.node.children
                  .map(
                    (child) => FileTreeItem(
                      node: child,
                      depth: widget.depth + 1,
                      onToggleExpansion: widget.onToggleExpansion,
                      onFileSelected: widget.onFileSelected,
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  IconData _getIcon(FileTreeNode node) {
    if (node.type == FileTreeNodeType.directory) {
      return node.isExpanded ? LucideIcons.folderOpen : LucideIcons.folder;
    }

    // File icon based on extension
    final extension = path.extension(node.name).toLowerCase();
    switch (extension) {
      case '.md':
      case '.markdown':
        return LucideIcons.fileText;
      case '.blox':
        return LucideIcons.box; // Custom format
      case '.txt':
        return LucideIcons.fileText;
      case '.json':
        return LucideIcons.braces;
      case '.yaml':
      case '.yml':
        return LucideIcons.fileCode2;
      case '.dart':
        return LucideIcons.fileCode;
      case '.js':
      case '.ts':
        return LucideIcons.fileCode;
      case '.py':
        return LucideIcons.fileCode;
      case '.html':
      case '.css':
        return LucideIcons.fileCode;
      case '.pdf':
        return LucideIcons.fileText;
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.gif':
      case '.svg':
        return LucideIcons.image;
      default:
        return LucideIcons.file;
    }
  }

  void _showContextMenu(
    BuildContext context,
    Offset position,
    FileTreeNode node,
  ) {
    final theme = Theme.of(context);
    final isDirectory = node.type == FileTreeNodeType.directory;

    // Get collection suggestions for files
    final suggestions = isDirectory
        ? <CollectionSuggestion>[]
        : SmartSuggestionService.getTopSuggestions(node.path);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'open',
          child: Row(
            children: [
              Icon(
                isDirectory ? LucideIcons.folderOpen : LucideIcons.file,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(isDirectory ? 'Open Folder' : 'Open File'),
            ],
          ),
        ),
        if (!isDirectory) ...[
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'open_new_tab',
            child: Row(
              children: [
                Icon(
                  Icons.tab,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                const Text('Open in New Tab'),
              ],
            ),
          ),
        ],
        // Collection suggestions
        if (suggestions.isNotEmpty) ...[
          const PopupMenuDivider(),
          ...suggestions.map(
            (suggestion) => PopupMenuItem<String>(
              value: 'add_to_collection_${suggestion.templateId}',
              child: Row(
                children: [
                  Icon(
                    getIconDataFromString(suggestion.icon),
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add to ${suggestion.displayName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(suggestion.confidence * 100).round()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'rename',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              const Text('Rename'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                size: 16,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                isDirectory ? 'Delete Folder' : 'Delete File',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null && context.mounted) {
        _handleContextMenuAction(context, value, node);
      }
    });
  }

  void _handleContextMenuAction(
    BuildContext context,
    String action,
    FileTreeNode node,
  ) {
    switch (action) {
      case 'open':
        if (node.type == FileTreeNodeType.directory) {
          widget.onToggleExpansion(node.path);
        } else {
          widget.onFileSelected(node.path);
        }
      case 'open_new_tab':
        if (node.type != FileTreeNodeType.directory) {
          widget.onFileSelected(node.path);
        }
      case 'rename':
        // Implement rename functionality
        _showRenameDialog(context, node);
      case 'delete':
        // Implement delete functionality
        _showDeleteConfirmationDialog(context, node);
      default:
        // Handle collection suggestion actions
        if (action.startsWith('add_to_collection_')) {
          final templateId = action.substring('add_to_collection_'.length);
          _handleAddToCollection(context, node, templateId);
        }
        break;
    }
  }

  void _handleAddToCollection(
    BuildContext context,
    FileTreeNode node,
    String templateId,
  ) {
    // Get the template
    final template = CollectionTemplates.getTemplate(templateId);
    if (template == null) return;

    // Create collection name from template
    final collectionName = template.name;

    // Use Riverpod to access the workspace provider
    ProviderScope.containerOf(context).read(currentWorkspaceProvider.notifier)
      ..createCollection(collectionName)
      ..addToCollection(collectionName, node.path);

    // Show success feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added ${path.basename(node.path)} to $collectionName collection',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showRenameDialog(BuildContext context, FileTreeNode node) {
    final controller = TextEditingController(text: path.basename(node.path));
    final extension = path.extension(node.path);
    final nameWithoutExtension = path.basenameWithoutExtension(node.path);
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            suffixText: extension.isNotEmpty ? extension : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty || newName == nameWithoutExtension) {
                Navigator.of(context).pop();
                return;
              }

              final newPath = path.join(
                path.dirname(node.path),
                extension.isNotEmpty ? '$newName$extension' : newName,
              );

              try {
                await ProviderScope.containerOf(context)
                    .read(currentWorkspaceProvider.notifier)
                    .renameItem(node.path, newPath);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Renamed to ${path.basename(newPath)}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to rename: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    FileTreeNode node,
  ) {
    final isDirectory = node.type == FileTreeNodeType.directory;
    final itemType = isDirectory ? 'directory' : 'file';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $itemType'),
        content: Text(
          'Are you sure you want to delete "${path.basename(node.path)}"? '
          '${isDirectory ? 'This will delete the directory and all its contents.' : ''} '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              try {
                await ProviderScope.containerOf(context)
                    .read(currentWorkspaceProvider.notifier)
                    .deleteItem(node.path);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$itemType deleted successfully'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete $itemType: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
