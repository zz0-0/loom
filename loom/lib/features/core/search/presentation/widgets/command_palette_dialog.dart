import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/search/presentation/widgets/global_search_dialog.dart';
import 'package:loom/shared/data/providers.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// VSCode-style command palette that searches for files and commands
class CommandPaletteDialog extends ConsumerStatefulWidget {
  const CommandPaletteDialog({super.key});

  @override
  ConsumerState<CommandPaletteDialog> createState() =>
      _CommandPaletteDialogState();
}

class _CommandPaletteDialogState extends ConsumerState<CommandPaletteDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<_PaletteItem> _filteredItems = [];
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _loadItems();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);

    final items = <_PaletteItem>[];

    // Add static command items
    final staticItems = [
      _PaletteItem(
        title: 'Search Files',
        subtitle: 'Search for files by name',
        icon: LucideIcons.search,
        action: _showFileSearch,
        category: 'Search',
      ),
      _PaletteItem(
        title: 'Search in Files',
        subtitle: 'Search for text content in files',
        icon: LucideIcons.fileSearch,
        action: _showContentSearch,
        category: 'Search',
      ),
      _PaletteItem(
        title: 'Open Folder',
        subtitle: 'Open a workspace folder',
        icon: LucideIcons.folderOpen,
        action: _openFolder,
        category: 'File',
      ),
      _PaletteItem(
        title: 'New File',
        subtitle: 'Create a new file',
        icon: LucideIcons.filePlus,
        action: _newFile,
        category: 'File',
      ),
      _PaletteItem(
        title: 'Settings',
        subtitle: 'Open settings',
        icon: LucideIcons.settings,
        action: _openSettings,
        category: 'View',
      ),
    ];

    // Load files from current workspace
    final fileItems = <_PaletteItem>[];
    try {
      final fileRepo = ref.read(fileRepositoryProvider);
      const workspacePath =
          '/workspaces'; // TODO(user): Get from workspace provider
      final files = await fileRepo.listFilesRecursively(workspacePath);

      for (final filePath in files) {
        final fileName = path.basename(filePath);
        final relativePath = path.relative(filePath, from: workspacePath);

        fileItems.add(
          _PaletteItem(
            title: fileName,
            subtitle: relativePath,
            icon: _getFileIcon(fileName),
            action: () => _openFile(filePath),
            category: 'Files',
            isFile: true,
          ),
        );
      }
    } catch (e) {
      // Handle error silently for now
    }

    final allItems = [...staticItems, ...fileItems];
    items.addAll(allItems);

    setState(() {
      _filteredItems = items;
      _isLoading = false;
    });
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      _loadItems();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filtered = _filteredItems.where((item) {
      return item.title.toLowerCase().contains(lowercaseQuery) ||
          item.subtitle.toLowerCase().contains(lowercaseQuery) ||
          item.category.toLowerCase().contains(lowercaseQuery);
    }).toList();

    // Sort by relevance (title matches first, then subtitle, then category)
    filtered.sort((a, b) {
      final aTitle = a.title.toLowerCase().contains(lowercaseQuery);
      final bTitle = b.title.toLowerCase().contains(lowercaseQuery);

      if (aTitle && !bTitle) return -1;
      if (!aTitle && bTitle) return 1;

      // If both or neither match title, sort alphabetically
      return a.title.compareTo(b.title);
    });

    setState(() {
      _filteredItems = filtered;
      _selectedIndex = 0;
    });
  }

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.md':
      case '.markdown':
        return LucideIcons.bookOpen;
      case '.dart':
        return LucideIcons.code;
      case '.json':
        return LucideIcons.braces;
      case '.yaml':
      case '.yml':
        return LucideIcons.settings;
      default:
        return LucideIcons.file;
    }
  }

  void _executeSelectedItem() {
    if (_filteredItems.isNotEmpty && _selectedIndex < _filteredItems.length) {
      final item = _filteredItems[_selectedIndex];
      Navigator.of(context).pop();
      item.action();
    }
  }

  void _showFileSearch() {
    // TODO(user): Implement file-only search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File search coming soon')),
    );
  }

  void _showContentSearch() {
    showDialog<void>(
      context: context,
      builder: (context) => const GlobalSearchDialog(),
    );
  }

  void _openFolder() {
    // TODO(user): Trigger open folder action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open folder action')),
    );
  }

  void _newFile() {
    // TODO(user): Trigger new file action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New file action')),
    );
  }

  void _openSettings() {
    // TODO(user): Navigate to settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings navigation')),
    );
  }

  void _openFile(String filePath) {
    // TODO(user): Open file in editor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening: ${path.basename(filePath)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    setState(() {
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        _selectedIndex =
                            (_selectedIndex + 1) % _filteredItems.length;
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowUp) {
                        _selectedIndex =
                            (_selectedIndex - 1 + _filteredItems.length) %
                                _filteredItems.length;
                      }
                    });

                    if (event.logicalKey == LogicalKeyboardKey.enter) {
                      _executeSelectedItem();
                    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type to search files and commands...',
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    border: InputBorder.none,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onChanged: _filterItems,
                ),
              ),
            ),

            // Results
            Flexible(
              child: _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.searchX,
                                  size: 48,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final isSelected = index == _selectedIndex;

                            return InkWell(
                              onTap: () {
                                setState(() => _selectedIndex = index);
                                _executeSelectedItem();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primaryContainer
                                          .withOpacity(0.3)
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      item.icon,
                                      size: 20,
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              fontWeight: isSelected
                                                  ? FontWeight.w500
                                                  : null,
                                              color: isSelected
                                                  ? theme.colorScheme.onSurface
                                                  : null,
                                            ),
                                          ),
                                          if (item.subtitle.isNotEmpty)
                                            Text(
                                              item.subtitle,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme.colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (!item.isFile)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme
                                              .surfaceContainerHighest,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),

            // Footer with help text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '↑↓ Navigate',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '↵ Select',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Esc Close',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteItem {
  const _PaletteItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.action,
    required this.category,
    this.isFile = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback action;
  final String category;
  final bool isFile;
}
