import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/features/core/search/index.dart';
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
      final workspace = ref.read(currentWorkspaceProvider);
      final workspacePath = workspace?.rootPath ?? '/workspaces';
      if (workspacePath == '/workspaces') {
        // No workspace opened, skip file listing
        return;
      }
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
    }).toList()

      // Sort by relevance (title matches first, then subtitle, then category)
      ..sort((a, b) {
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
    // Show a simple file search dialog
    showDialog<void>(
      context: context,
      builder: (context) => const _FileSearchDialog(),
    );
  }

  void _showContentSearch() {
    showDialog<void>(
      context: context,
      builder: (context) => const GlobalSearchDialog(),
    );
  }

  void _openFolder() {
    // Trigger open folder dialog from desktop layout
    // This would need to be coordinated with the desktop layout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Use File > Open to open a folder')),
    );
  }

  void _newFile() {
    // Trigger new file creation from content area
    // This would need to be coordinated with the content area
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Use the welcome screen to create a new file'),
      ),
    );
  }

  void _openSettings() {
    // Navigate to settings - this would need integration with the UI registry
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings panel coming soon')),
    );
  }

  void _openFile(String filePath) {
    final container = ProviderScope.containerOf(context, listen: false);
    container.read(fileOpeningServiceProvider).openFile(filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opened: ${path.basename(filePath)}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 550,
        constraints: const BoxConstraints(maxHeight: 450),
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
              padding: AppSpacing.paddingSm,
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
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    border: InputBorder.none,
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
                        padding: AppSpacing.paddingLg,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _filteredItems.isEmpty
                      ? Center(
                          child: Padding(
                            padding: AppSpacing.paddingLg,
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
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
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
              padding: AppSpacing.paddingSm,
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

/// Simple file search dialog for finding files by name
class _FileSearchDialog extends StatefulWidget {
  const _FileSearchDialog();

  @override
  State<_FileSearchDialog> createState() => _FileSearchDialogState();
}

class _FileSearchDialogState extends State<_FileSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _allFiles = [];
  List<String> _filteredFiles = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _loadFiles();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    try {
      final container = ProviderScope.containerOf(context, listen: false);
      final workspace = container.read(currentWorkspaceProvider);
      final workspacePath = workspace?.rootPath ?? '/workspaces';

      if (workspacePath == '/workspaces') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final fileRepo = container.read(fileRepositoryProvider);
      final files = await fileRepo.listFilesRecursively(workspacePath);

      setState(() {
        _allFiles = files;
        _filteredFiles = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterFiles(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFiles = _allFiles;
        _selectedIndex = 0;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filtered = _allFiles.where((filePath) {
      final fileName = path.basename(filePath).toLowerCase();
      final relativePath = path
          .relative(
            filePath,
            from: _allFiles.isNotEmpty ? path.dirname(_allFiles.first) : '',
          )
          .toLowerCase();
      return fileName.contains(lowercaseQuery) ||
          relativePath.contains(lowercaseQuery);
    }).toList()

      // Sort by relevance (filename matches first, then path matches)
      ..sort((a, b) {
        final aFileName = path.basename(a).toLowerCase();
        final bFileName = path.basename(b).toLowerCase();
        final aStartsWith = aFileName.startsWith(lowercaseQuery);
        final bStartsWith = bFileName.startsWith(lowercaseQuery);

        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;

        return aFileName.compareTo(bFileName);
      });

    setState(() {
      _filteredFiles = filtered;
      _selectedIndex = 0;
    });
  }

  void _openSelectedFile() {
    if (_filteredFiles.isNotEmpty && _selectedIndex < _filteredFiles.length) {
      final filePath = _filteredFiles[_selectedIndex];
      final container = ProviderScope.containerOf(context, listen: false);
      container.read(fileOpeningServiceProvider).openFile(filePath);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opened: ${path.basename(filePath)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 550,
        height: 350,
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
          children: [
            // Header
            Container(
              padding: AppSpacing.paddingSm,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.fileSearch,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Find File',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Search input
            Container(
              padding: AppSpacing.paddingSm,
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    setState(() {
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        _selectedIndex =
                            (_selectedIndex + 1) % _filteredFiles.length;
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowUp) {
                        _selectedIndex =
                            (_selectedIndex - 1 + _filteredFiles.length) %
                                _filteredFiles.length;
                      }
                    });

                    if (event.logicalKey == LogicalKeyboardKey.enter) {
                      _openSelectedFile();
                    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type to search files...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _filterFiles,
                ),
              ),
            ),

            // Results
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _filteredFiles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.fileX,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _controller.text.isEmpty
                                    ? 'No files found in workspace'
                                    : 'No files match your search',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredFiles.length,
                          itemBuilder: (context, index) {
                            final filePath = _filteredFiles[index];
                            final fileName = path.basename(filePath);
                            final relativePath = _allFiles.isNotEmpty
                                ? path.relative(
                                    filePath,
                                    from: path.dirname(_allFiles.first),
                                  )
                                : filePath;
                            final isSelected = index == _selectedIndex;

                            return InkWell(
                              onTap: () {
                                setState(() => _selectedIndex = index);
                                _openSelectedFile();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
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
                                      _getFileIcon(fileName),
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
                                            fileName,
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
                                          Text(
                                            relativePath,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),

            // Footer
            Container(
              padding: AppSpacing.paddingSm,
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
                    '${_filteredFiles.length} files',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '↑↓ Navigate • ↵ Open • Esc Close',
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

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.dart':
        return LucideIcons.fileCode;
      case '.yaml':
      case '.yml':
        return LucideIcons.fileCode2;
      case '.json':
        return LucideIcons.braces;
      case '.md':
        return LucideIcons.fileText;
      default:
        return LucideIcons.file;
    }
  }
}
