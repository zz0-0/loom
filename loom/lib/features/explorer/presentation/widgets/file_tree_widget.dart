import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/models/workspace_settings.dart'
    as models;
import 'package:loom/features/explorer/presentation/providers/workspace_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Widget that displays the file system tree
class FileTreeWidget extends ConsumerWidget {
  const FileTreeWidget({
    required this.workspace,
    super.key,
  });

  final models.Workspace workspace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (workspace.fileTree.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
            // TODO(user): Open file in editor
            // For now, we'll use the existing UI state provider
            // ref.read(uiStateProvider.notifier).openFile(filePath);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
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

  final models.FileTreeNode node;
  final int depth;
  final ValueChanged<String> onToggleExpansion;
  final ValueChanged<String> onFileSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDirectory = node.type == models.FileTreeNodeType.directory;
    final hasChildren = node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current node
        Material(
          color: Colors.transparent,
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
                left: 8.0 + (depth * 16.0),
                right: 8,
                top: 4,
                bottom: 4,
              ),
              child: Row(
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

  IconData _getIcon(models.FileTreeNode node) {
    if (node.type == models.FileTreeNodeType.directory) {
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
}
