import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/file_tree/presentation/widgets/file_tree_item.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Widget that displays the file system tree
class FileTreeWidget extends ConsumerStatefulWidget {
  const FileTreeWidget({
    required this.workspace,
    super.key,
  });

  final Workspace workspace;

  @override
  ConsumerState<FileTreeWidget> createState() => _FileTreeWidgetState();
}

class _FileTreeWidgetState extends ConsumerState<FileTreeWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<FileTreeNode> _filteredNodes = [];

  @override
  void initState() {
    super.initState();
    _filteredNodes = widget.workspace.fileTree;
  }

  @override
  void didUpdateWidget(FileTreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workspace != oldWidget.workspace) {
      _applyFilter();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase().trim();
      _applyFilter();
    });
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredNodes = widget.workspace.fileTree;
      });
      return;
    }

    setState(() {
      _filteredNodes = _filterNodes(widget.workspace.fileTree);
    });
  }

  List<FileTreeNode> _filterNodes(List<FileTreeNode> nodes) {
    final filtered = <FileTreeNode>[];

    for (final node in nodes) {
      final matchesSearch = node.name.toLowerCase().contains(_searchQuery) ||
          path.basename(node.path).toLowerCase().contains(_searchQuery);

      if (node.type == FileTreeNodeType.directory) {
        // For directories, check if any children match
        final filteredChildren = _filterNodes(node.children);

        if (matchesSearch || filteredChildren.isNotEmpty) {
          filtered.add(
            FileTreeNode(
              name: node.name,
              path: node.path,
              type: node.type,
              isExpanded: _searchQuery.isNotEmpty || node.isExpanded,
              children: filteredChildren,
              lastModified: node.lastModified,
              size: node.size,
            ),
          );
        }
      } else if (matchesSearch) {
        // For files, add if they match
        filtered.add(node);
      }
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search field
        Container(
          padding: AppSpacing.paddingHorizontalSm,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search files...',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              prefixIcon: const Icon(Icons.search, size: 16),
              border: InputBorder.none,
              contentPadding: AppSpacing.paddingVerticalSm,
              isDense: true,
            ),
            style: theme.textTheme.bodySmall,
            onChanged: _onSearchChanged,
          ),
        ),

        // File tree
        Expanded(
          child: _filteredNodes.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: AppSpacing.paddingVerticalXs,
                  itemCount: _filteredNodes.length,
                  itemBuilder: (context, index) {
                    final node = _filteredNodes[index];
                    return FileTreeItem(
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
