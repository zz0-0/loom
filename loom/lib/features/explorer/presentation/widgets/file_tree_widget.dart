import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/models/collection_template.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart'
    as domain;
import 'package:loom/features/explorer/domain/services/smart_categorization_service.dart';
import 'package:loom/features/explorer/presentation/providers/workspace_provider.dart';
import 'package:loom/shared/presentation/providers/tab_provider.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Widget that displays the file system tree
class FileTreeWidget extends ConsumerWidget {
  const FileTreeWidget({
    required this.workspace,
    super.key,
  });

  final domain.Workspace workspace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Search field
        Container(
          padding: AppSpacing.paddingHorizontalSm,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search files...',
              prefixIcon: Icon(Icons.search, size: 16),
              border: InputBorder.none,
              contentPadding: AppSpacing.paddingVerticalSm,
              isDense: true,
            ),
            style: Theme.of(context).textTheme.bodySmall,
            onChanged: (query) {
              // TODO(user): Implement search filtering
            },
          ),
        ),

        // File tree
        Expanded(
          child: workspace.fileTree.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: AppSpacing.paddingVerticalXs,
                  itemCount: workspace.fileTree.length,
                  itemBuilder: (context, index) {
                    final node = workspace.fileTree[index];
                    return _FileTreeItem(
                      node: node,
                      depth: 0,
                      onToggleExpansion: (nodePath) {
                        ref
                            .read(currentWorkspaceProvider.notifier)
                            .toggleDirectoryExpansion(nodePath);
                      },
                      onFileSelected: (filePath) {
                        // Open file in editor
                        final fileName = path.basename(filePath);
                        ref.read(tabProvider.notifier).openTab(
                              id: filePath,
                              title: fileName,
                              contentType: 'file',
                            );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.folderX,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No files found',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual file tree item widget
class _FileTreeItem extends StatelessWidget {
  const _FileTreeItem({
    required this.node,
    required this.depth,
    required this.onToggleExpansion,
    required this.onFileSelected,
  });

  final domain.FileTreeNode node;
  final int depth;
  final ValueChanged<String> onToggleExpansion;
  final ValueChanged<String> onFileSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDirectory = node.type == domain.FileTreeNodeType.directory;
    final hasChildren = node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current node
        Material(
          color: Colors.transparent,
          child: GestureDetector(
            onSecondaryTapDown: (details) =>
                _showContextMenu(context, details.globalPosition, node),
            child: InkWell(
              onTap: () {
                if (isDirectory) {
                  onToggleExpansion(node.path);
                } else {
                  onFileSelected(node.path);
                }
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: AppSpacing.sm + (depth * 16.0),
                  right: AppSpacing.sm,
                  top: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                ),
                child: Stack(
                  children: [
                    // Indentation guides
                    if (depth > 0)
                      Positioned.fill(
                        child: Row(
                          children: List.generate(depth, (index) {
                            final isLast = index == depth - 1;
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
                        // Expansion indicator
                        if (isDirectory)
                          Icon(
                            hasChildren
                                ? (node.isExpanded
                                    ? LucideIcons.chevronDown
                                    : LucideIcons.chevronRight)
                                : LucideIcons.chevronRight,
                            size: 12,
                            color: hasChildren
                                ? theme.colorScheme.onSurfaceVariant
                                : Colors.transparent,
                          )
                        else
                          const SizedBox(width: 12),

                        const SizedBox(width: 4),

                        // File/folder icon
                        Icon(
                          _getIcon(node),
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),

                        const SizedBox(width: 6),

                        // File/folder name
                        Expanded(
                          child: Text(
                            node.name,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
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

        // Children (if expanded)
        if (isDirectory && node.isExpanded && hasChildren)
          ...node.children.map(
            (child) => _FileTreeItem(
              node: child,
              depth: depth + 1,
              onToggleExpansion: onToggleExpansion,
              onFileSelected: onFileSelected,
            ),
          ),
      ],
    );
  }

  IconData _getIcon(domain.FileTreeNode node) {
    if (node.type == domain.FileTreeNodeType.directory) {
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
    domain.FileTreeNode node,
  ) {
    final theme = Theme.of(context);
    final isDirectory = node.type == domain.FileTreeNodeType.directory;

    // Get collection suggestions for files
    final suggestions = isDirectory
        ? <CollectionSuggestion>[]
        : SmartCategorizationService.getTopSuggestions(node.path);

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
                    suggestion.icon,
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
      if (value != null) {
        _handleContextMenuAction(context, value, node);
      }
    });
  }

  void _handleContextMenuAction(
    BuildContext context,
    String action,
    domain.FileTreeNode node,
  ) {
    switch (action) {
      case 'open':
        if (node.type == domain.FileTreeNodeType.directory) {
          onToggleExpansion(node.path);
        } else {
          onFileSelected(node.path);
        }
      case 'open_new_tab':
        if (node.type != domain.FileTreeNodeType.directory) {
          onFileSelected(node.path);
        }
      case 'rename':
        // TODO(user): Implement rename functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rename functionality coming soon')),
        );
      case 'delete':
        // TODO(user): Implement delete functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete functionality coming soon')),
        );
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
    domain.FileTreeNode node,
    String templateId,
  ) {
    // Get the template
    final template = CollectionTemplates.getTemplate(templateId);
    if (template == null) return;

    // Create collection name from template
    final collectionName = template.name;

    // Use Riverpod to access the workspace provider
    final container = ProviderScope.containerOf(context);
    final workspaceNotifier = container.read(currentWorkspaceProvider.notifier);

    // Create collection if it doesn't exist
    workspaceNotifier.createCollection(collectionName);

    // Add file to collection
    workspaceNotifier.addToCollection(collectionName, node.path);

    // Show success feedback
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
