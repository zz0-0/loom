import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/panels/resizable_side_panel.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/features/core/plugin_system/index.dart';
import 'package:loom/features/core/search/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:path/path.dart' as path;
import 'package:window_manager/window_manager.dart';

/// Extensible desktop layout with customizable UI components
/// This serves as the main UI scaffold that features can register into
class DesktopLayout extends ConsumerStatefulWidget {
  const DesktopLayout({required this.pluginBootstrapper, super.key});

  final PluginBootstrapper pluginBootstrapper;

  @override
  ConsumerState<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<DesktopLayout> {
  @override
  void initState() {
    super.initState();
    _initializePluginSystem();
    _registerDefaultComponents();
  }

  /// Initialize the plugin system
  Future<void> _initializePluginSystem() async {
    try {
      await widget.pluginBootstrapper.initializePlugins(context);
    } catch (e) {
      debugPrint('Failed to initialize plugin system: $e');
    }
  }

  /// Register default UI components
  void _registerDefaultComponents() {
    final menuRegistry = MenuRegistry();

    // Register file content provider
    UIRegistry().registerContentProvider(FileContentProvider());

    // Register feature components
    _registerFeatures();

    // Register default menus
    menuRegistry.registerMenus([
      SimpleMenuItem(
        label: 'File',
        children: [
          SimpleMenuItem(
            label: 'New',
            icon: Icons.add,
            onPressedWithContext: _handleNewFile,
          ),
          SimpleMenuItem(
            label: 'Open Folder',
            icon: Icons.folder_open,
            onPressedWithContext: (context) =>
                ref.read(currentFolderProvider.notifier).openFolder(context),
          ),
          SimpleMenuItem(
            label: 'Save',
            icon: Icons.save,
            onPressedWithContext: _handleSave,
          ),
          SimpleMenuItem(
            label: 'Save As',
            icon: Icons.save_as,
            onPressedWithContext: _handleSaveAs,
          ),
          SimpleMenuItem(
            label: 'Export',
            icon: Icons.file_download,
            onPressedWithContext: _handleExport,
          ),
          SimpleMenuItem(
            label: 'Exit',
            icon: Icons.exit_to_app,
            onPressedWithContext: _handleExit,
          ),
        ],
      ),
      SimpleMenuItem(
        label: 'Edit',
        children: [
          SimpleMenuItem(
            label: 'Undo',
            icon: Icons.undo,
            onPressedWithContext: _handleUndo,
          ),
          SimpleMenuItem(
            label: 'Redo',
            icon: Icons.redo,
            onPressedWithContext: _handleRedo,
          ),
          SimpleMenuItem(
            label: 'Cut',
            icon: Icons.content_cut,
            onPressedWithContext: _handleCut,
          ),
          SimpleMenuItem(
            label: 'Copy',
            icon: Icons.copy,
            onPressedWithContext: _handleCopy,
          ),
          SimpleMenuItem(
            label: 'Paste',
            icon: Icons.paste,
            onPressedWithContext: _handlePaste,
          ),
        ],
      ),
      SimpleMenuItem(
        label: 'View',
        children: [
          SimpleMenuItem(
            label: 'Toggle Sidebar',
            onPressedWithContext: _handleToggleSidebar,
          ),
          SimpleMenuItem(
            label: 'Toggle Panel',
            onPressedWithContext: _handleTogglePanel,
          ),
          SimpleMenuItem(
            label: 'Full Screen',
            onPressedWithContext: _handleFullScreen,
          ),
        ],
      ),
      SimpleMenuItem(
        label: 'Help',
        children: [
          SimpleMenuItem(
            label: 'Documentation',
            onPressedWithContext: _handleDocumentation,
          ),
          SimpleMenuItem(
            label: 'About',
            onPressedWithContext: _handleAbout,
          ),
        ],
      ),
    ]);

    // Future features can register their own components here
  }

  /// Register all features
  void _registerFeatures() {
    // Import feature registrations
    // Note: These imports are done here to avoid circular dependencies
    // and to ensure features are registered at the right time

    try {
      // Register explorer feature
      // We can't directly import due to potential circular dependencies,
      // so we'll register the components directly
      _registerExplorerFeature();
      _registerSettingsFeature();
      _registerSearchFeature();
    } catch (e) {
      // If feature registration fails, continue without them
      debugPrint('Feature registration failed: $e');
    }
  }

  void _registerExplorerFeature() {
    // Import the explorer feature registration
    // This is a workaround for the circular dependency issue
    final explorerItem = ExplorerSidebarItem();
    UIRegistry().registerSidebarItem(explorerItem);
  }

  void _registerSettingsFeature() {
    final settingsItem = SettingsSidebarItem();
    UIRegistry().registerSidebarItem(settingsItem);

    // Register settings content providers
    UIRegistry()
      ..registerContentProvider(SettingsContentProvider())
      ..registerContentProvider(AppearanceSettingsContentProvider())
      ..registerContentProvider(InterfaceSettingsContentProvider())
      ..registerContentProvider(GeneralSettingsContentProvider())
      ..registerContentProvider(AboutSettingsContentProvider());
  }

  void _registerSearchFeature() {
    // Register search feature
    final searchItem = SearchSidebarItem();
    UIRegistry().registerSidebarItem(searchItem);
  }

  void _showGlobalSearchDialog(BuildContext context) {
    // Implement global search dialog
    showDialog<void>(
      context: context,
      builder: (context) => const GlobalSearchDialog(),
    );
  }

  // Menu item handlers
  void _handleNewFile(BuildContext context) {
    final workspace = ref.read(currentWorkspaceProvider);
    if (workspace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please open a folder first to create a new file'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show new file dialog
    _showNewFileDialog(context);
  }

  void _handleSave(BuildContext context) {
    final editorState = ref.read(editorStateProvider);

    if (editorState.filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file is currently open to save'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Save the current content
    ref.read(fileContentProvider.notifier).saveFile(
          editorState.filePath!,
          editorState.content,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File "${editorState.filePath!.split('/').last}" saved'),
      ),
    );
  }

  void _handleSaveAs(BuildContext context) {
    final editorState = ref.read(editorStateProvider);
    _showSaveAsDialog(context, editorState.content);
  }

  void _handleExport(BuildContext context) {
    final editorState = ref.read(editorStateProvider);

    if (editorState.content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No content to export'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _showExportDialog(context, editorState.content);
  }

  void _handleExit(BuildContext context) {
    // Show confirmation dialog before exiting
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Application'),
        content: const Text('Are you sure you want to exit Loom?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Close the application using window_manager
              try {
                await windowManager.close();
              } catch (e) {
                // Fallback: use system exit if window_manager fails
                // This is a last resort and may not work on all platforms
                // ignore: avoid_print
                print('Failed to close window gracefully: $e');
              }
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _handleUndo(BuildContext context) {
    final editHistoryService = ref.read(editHistoryServiceProvider);
    final editorState = ref.read(editorStateProvider);

    if (editHistoryService.canUndo) {
      final previousContent = editHistoryService.undo();
      if (previousContent != null) {
        ref.read(editorStateProvider.notifier).updateContent(previousContent);
        // Also update the file content if needed
        if (editorState.filePath != null) {
          ref.read(fileContentProvider.notifier).updateContent(previousContent);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to undo')),
      );
    }
  }

  void _handleRedo(BuildContext context) {
    final editHistoryService = ref.read(editHistoryServiceProvider);
    final editorState = ref.read(editorStateProvider);

    if (editHistoryService.canRedo) {
      final nextContent = editHistoryService.redo();
      if (nextContent != null) {
        ref.read(editorStateProvider.notifier).updateContent(nextContent);
        // Also update the file content if needed
        if (editorState.filePath != null) {
          ref.read(fileContentProvider.notifier).updateContent(nextContent);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to redo')),
      );
    }
  }

  Future<void> _handleCut(BuildContext context) async {
    final editorState = ref.read(editorStateProvider);

    if (editorState.content.isNotEmpty) {
      // Copy content to clipboard
      await Clipboard.setData(ClipboardData(text: editorState.content));
      // Clear the content
      ref.read(editorStateProvider.notifier).updateContent('');
      if (editorState.filePath != null) {
        ref.read(fileContentProvider.notifier).updateContent('');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content cut to clipboard')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No content to cut')),
        );
      }
    }
  }

  Future<void> _handleCopy(BuildContext context) async {
    final editorState = ref.read(editorStateProvider);

    if (editorState.content.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: editorState.content));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content copied to clipboard')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No content to copy')),
        );
      }
    }
  }

  Future<void> _handlePaste(BuildContext context) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text;

    if (text != null && text.isNotEmpty) {
      final editorState = ref.read(editorStateProvider);
      final newContent = editorState.content + text;
      ref.read(editorStateProvider.notifier).updateContent(newContent);
      if (editorState.filePath != null) {
        ref.read(fileContentProvider.notifier).updateContent(newContent);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content pasted from clipboard')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No text in clipboard to paste')),
        );
      }
    }
  }

  void _handleToggleSidebar(BuildContext context) {
    ref.read(uiStateProvider.notifier).toggleSidebar();
  }

  void _handleTogglePanel(BuildContext context) {
    final uiState = ref.read(uiStateProvider);
    if (uiState.isSidePanelVisible) {
      ref.read(uiStateProvider.notifier).hideSidePanel();
    } else {
      // Show side panel if there's a selected item, otherwise show a message
      if (uiState.selectedSidebarItem != null) {
        ref.read(uiStateProvider.notifier).showSidePanel();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an item from the sidebar first'),
          ),
        );
      }
    }
  }

  Future<void> _handleFullScreen(BuildContext context) async {
    // Toggle full screen using window_manager
    final isCurrentlyFullScreen = await windowManager.isFullScreen();
    await windowManager.setFullScreen(!isCurrentlyFullScreen);
  }

  void _handleDocumentation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Loom Documentation'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Loom!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Loom is a knowledge base application for organizing and editing documents.',
            ),
            SizedBox(height: 16),
            Text(
              'Key Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• File Explorer: Browse and manage your files'),
            Text('• Rich Text Editor: Edit documents with syntax highlighting'),
            Text('• Search: Find files and content quickly'),
            Text('• Settings: Customize your experience'),
            SizedBox(height: 16),
            Text(
              'Keyboard Shortcuts:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• Ctrl+S: Save file'),
            Text('• Ctrl+Shift+F: Global search'),
            Text('• Ctrl+Z: Undo'),
            Text('• Ctrl+Y: Redo'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const AboutDialog(
        applicationName: 'Loom',
        applicationVersion: '1.0.0',
        applicationLegalese: '© 2025 Loom Team',
        children: [
          SizedBox(height: 16),
          Text(
            'Loom is a knowledge base application for organizing and editing documents.',
          ),
        ],
      ),
    );
  }

  void _showNewFileDialog(BuildContext context) {
    final controller = TextEditingController();
    final workspace = ref.read(currentWorkspaceProvider);
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'File name',
            hintText: 'Enter file name (e.g., example.blox)',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final fileName = controller.text.trim();

              if (fileName.isNotEmpty && workspace != null) {
                // Input validation
                if (fileName.isEmpty || fileName.length > 255) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid file name')),
                  );
                  return;
                }

                // Prevent directory traversal
                if (fileName.contains('..') ||
                    fileName.contains('/') ||
                    fileName.contains(r'\')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid characters in file name'),
                    ),
                  );
                  return;
                }

                try {
                  final filePath = path.join(workspace.rootPath, fileName);

                  // Use repository through use case for security validation
                  final createFileUseCase =
                      ref.read(workspaceCreateFileUseCaseProvider);
                  await createFileUseCase.call(workspace.rootPath, filePath);

                  // Refresh the file tree
                  await ref
                      .read(currentWorkspaceProvider.notifier)
                      .refreshFileTree();

                  if (context.mounted) {
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File "$fileName" created')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create file: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, String content) {
    final fileNameController = TextEditingController();
    final locationController = TextEditingController();
    final formatController = TextEditingController(text: 'txt');
    final workspace = ref.read(currentWorkspaceProvider);

    // Default to current workspace or home directory
    locationController.text = workspace?.rootPath ?? '/workspaces';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                labelText: 'File name',
                hintText: 'Enter file name (without extension)',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter export location',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: formatController,
              decoration: const InputDecoration(
                labelText: 'Format',
                hintText: 'txt, md, html, etc.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final fileName = fileNameController.text.trim();
              final location = locationController.text.trim();
              final format = formatController.text.trim();

              if (fileName.isNotEmpty &&
                  location.isNotEmpty &&
                  format.isNotEmpty) {
                try {
                  final filePath = path.join(location, '$fileName.$format');

                  // Export the file (for now, just save as plain text)
                  await ref
                      .read(fileContentProvider.notifier)
                      .saveFile(filePath, content);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('File exported as "$fileName.$format"'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to export file: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showSaveAsDialog(BuildContext context, String content) {
    final fileNameController = TextEditingController();
    final locationController = TextEditingController();
    final workspace = ref.read(currentWorkspaceProvider);

    // Default to current workspace or home directory
    locationController.text = workspace?.rootPath ?? '/workspaces';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save As'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                labelText: 'File name',
                hintText: 'Enter file name (e.g., document.blox)',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Enter save location',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final fileName = fileNameController.text.trim();
              final location = locationController.text.trim();

              if (fileName.isNotEmpty && location.isNotEmpty) {
                try {
                  final filePath = path.join(location, fileName);

                  // Save the file
                  await ref
                      .read(fileContentProvider.notifier)
                      .saveFile(filePath, content);

                  // Update editor state with new file path
                  ref
                      .read(editorStateProvider.notifier)
                      .updateFilePath(filePath);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File saved as "$fileName"')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to save file: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(uiStateProvider);

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Handle global shortcuts
          if (HardwareKeyboard.instance.isControlPressed &&
              HardwareKeyboard.instance.isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.keyF) {
            _showGlobalSearchDialog(context);
            return KeyEventResult.handled;
          }
          // Export shortcut removed (Ctrl+E)
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        body: Column(
          children: [
            // Top bar with registered items and window controls
            SizedBox(
              height: AdaptiveConstants.topBarHeight(context),
              child: const TopBar(),
            ),

            // Main content area
            Expanded(
              child: Row(
                children: [
                  // Extensible sidebar (icon-only)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: uiState.isSidebarCollapsed
                        ? 0
                        : AppTheme.sidebarCollapsedWidth,
                    child: uiState.isSidebarCollapsed
                        ? null
                        : const ExtensibleSidebar(),
                  ),

                  // Extensible side panel
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width:
                        uiState.isSidePanelVisible ? uiState.sidePanelWidth : 0,
                    child: uiState.isSidePanelVisible
                        ? ResizableSidePanel(
                            onWidthChanged: (width) {
                              ref
                                  .read(uiStateProvider.notifier)
                                  .updateSidePanelWidth(width);
                            },
                            child: ExtensibleSidePanel(
                              selectedItemId: uiState.selectedSidebarItem,
                              onClose: () {
                                ref
                                    .read(uiStateProvider.notifier)
                                    .hideSidePanel();
                              },
                            ),
                          )
                        : null,
                  ),

                  // Extensible main content area
                  Expanded(
                    child: ExtensibleContentArea(
                      contentId: uiState.openedFile,
                    ),
                  ),
                ],
              ),
            ),

            // Extensible bottom bar
            const BottomBar(),
          ],
        ),
      ),
    );
  }
}

/// Search top bar item - removed as search is now in sidebar
