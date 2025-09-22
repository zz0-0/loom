import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/panels/resizable_side_panel.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/features/core/search/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loom/plugins/core/plugin_manager.dart';
import 'package:loom/plugins/core/presentation/plugin_sidebar_item.dart';
import 'package:path/path.dart' as path;
import 'package:window_manager/window_manager.dart';

/// Extensible desktop layout with customizable UI components
/// This serves as the main UI scaffold that features can register into
class DesktopLayout extends ConsumerStatefulWidget {
  const DesktopLayout({super.key});

  @override
  ConsumerState<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<DesktopLayout> {
  bool _isInitialized = false;
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    // Only initialize plugin UI hooks when plugins are enabled explicitly.
    final pluginsEnabled = Platform.environment['ENABLE_PLUGINS'] == 'true';

    if (pluginsEnabled) {
      _initializePluginSystem();

      // Register plugin sidebar items after the UI is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _registerPluginSidebarItems();
      });
    } else {
      debugPrint(
        'Plugins disabled via ENABLE_PLUGINS; skipping plugin UI init',
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Register default components after dependencies are available
    // This ensures AppLocalizations is available
    if (!_isInitialized) {
      _isInitialized = true;
      // Defer menu registration to ensure localization is fully available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _registerDefaultComponents();
      });
    }
  }

  /// Initialize the plugin system
  Future<void> _initializePluginSystem() async {
    try {
      // Plugin system v2.0 is already initialized in main.dart
      // We can handle any UI-specific plugin initialization here if needed
      await PluginManager.instance
          .handleUIEvent('layout_initialized', {'layout': 'desktop'});
    } catch (e) {
      debugPrint('Failed to initialize plugin system: $e');
    }
  }

  /// Register default UI components
  void _registerDefaultComponents() {
    final menuRegistry = MenuRegistry();
    final l10n = AppLocalizations.of(context);

    // Register file content provider
    UIRegistry().registerContentProvider(FileContentProvider());

    // Register feature components
    _registerFeatures();

    // Register default menus
    final menus = <MenuItem>[
      SimpleMenuItem(
        label: l10n.file,
        children: [
          SimpleMenuItem(
            label: l10n.newFile,
            icon: Icons.add,
            onPressedWithContext: _handleNewFile,
          ),
          SimpleMenuItem(
            label: l10n.openFolder,
            icon: Icons.folder_open,
            onPressedWithContext: (context) =>
                ref.read(currentFolderProvider.notifier).openFolder(context),
          ),
          SimpleMenuItem(
            label: l10n.save,
            icon: Icons.save,
            onPressedWithContext: _handleSave,
          ),
          SimpleMenuItem(
            label: l10n.saveAs,
            icon: Icons.save_as,
            onPressedWithContext: _handleSaveAs,
          ),
          SimpleMenuItem(
            label: l10n.export,
            icon: Icons.file_download,
            onPressedWithContext: _handleExport,
          ),
          SimpleMenuItem(
            label: l10n.exit,
            icon: Icons.exit_to_app,
            onPressedWithContext: _handleExit,
          ),
        ],
      ),
      SimpleMenuItem(
        label: l10n.edit,
        children: [
          SimpleMenuItem(
            label: l10n.undo,
            icon: Icons.undo,
            onPressedWithContext: _handleUndo,
          ),
          SimpleMenuItem(
            label: l10n.redo,
            icon: Icons.redo,
            onPressedWithContext: _handleRedo,
          ),
          SimpleMenuItem(
            label: l10n.cut,
            icon: Icons.content_cut,
            onPressedWithContext: _handleCut,
          ),
          SimpleMenuItem(
            label: l10n.copy,
            icon: Icons.copy,
            onPressedWithContext: _handleCopy,
          ),
          SimpleMenuItem(
            label: l10n.paste,
            icon: Icons.paste,
            onPressedWithContext: _handlePaste,
          ),
        ],
      ),
      SimpleMenuItem(
        label: l10n.view,
        children: [
          SimpleMenuItem(
            label: l10n.toggleSidebar,
            onPressedWithContext: _handleToggleSidebar,
          ),
          SimpleMenuItem(
            label: l10n.togglePanel,
            onPressedWithContext: _handleTogglePanel,
          ),
          SimpleMenuItem(
            label: l10n.fullScreen,
            onPressedWithContext: _handleFullScreen,
          ),
        ],
      ),
      SimpleMenuItem(
        label: l10n.help,
        children: [
          SimpleMenuItem(
            label: l10n.documentation,
            onPressedWithContext: _handleDocumentation,
          ),
          SimpleMenuItem(
            label: l10n.about,
            onPressedWithContext: _handleAbout,
          ),
        ],
      ),
    ];

    // Add Plugins menu only when plugins are enabled
    if (Platform.environment['ENABLE_PLUGINS'] == 'true') {
      menus.add(
        SimpleMenuItem(
          label: l10n.plugins,
          children: _buildPluginMenuItems(context),
        ),
      );
    }

    menuRegistry.registerMenus(menus);

    // Future features can register their own components here
  }

  /// Re-register menus when locale changes
  void _reRegisterMenus() {
    debugPrint('🔄 Re-registering menus for locale change');
    final menuRegistry = MenuRegistry();

    final l10n = AppLocalizations.of(context);

    // Clear existing menus and re-register default menus with new locale
    menuRegistry.clear();
    final menus = <MenuItem>[
      SimpleMenuItem(
        label: l10n.file,
        children: [
          SimpleMenuItem(
            label: l10n.newFile,
            icon: Icons.add,
            onPressedWithContext: _handleNewFile,
          ),
          SimpleMenuItem(
            label: l10n.openFolder,
            icon: Icons.folder_open,
            onPressedWithContext: (context) =>
                ref.read(currentFolderProvider.notifier).openFolder(context),
          ),
          SimpleMenuItem(
            label: l10n.save,
            icon: Icons.save,
            onPressedWithContext: _handleSave,
          ),
          SimpleMenuItem(
            label: l10n.saveAs,
            icon: Icons.save_as,
            onPressedWithContext: _handleSaveAs,
          ),
          SimpleMenuItem(
            label: l10n.export,
            icon: Icons.file_download,
            onPressedWithContext: _handleExport,
          ),
          SimpleMenuItem(
            label: l10n.exit,
            icon: Icons.exit_to_app,
            onPressedWithContext: _handleExit,
          ),
        ],
      ),
      SimpleMenuItem(
        label: l10n.edit,
        children: [
          SimpleMenuItem(
            label: l10n.undo,
            icon: Icons.undo,
            onPressedWithContext: _handleUndo,
          ),
          SimpleMenuItem(
            label: l10n.redo,
            icon: Icons.redo,
            onPressedWithContext: _handleRedo,
          ),
          SimpleMenuItem(
            label: l10n.cut,
            icon: Icons.content_cut,
            onPressedWithContext: _handleCut,
          ),
          SimpleMenuItem(
            label: l10n.copy,
            icon: Icons.copy,
            onPressedWithContext: _handleCopy,
          ),
          SimpleMenuItem(
            label: l10n.paste,
            icon: Icons.paste,
            onPressedWithContext: _handlePaste,
          ),
        ],
      ),
      SimpleMenuItem(
        label: l10n.view,
        children: [
          SimpleMenuItem(
            label: l10n.toggleSidebar,
            onPressedWithContext: _handleToggleSidebar,
          ),
          SimpleMenuItem(
            label: l10n.togglePanel,
            onPressedWithContext: _handleTogglePanel,
          ),
          SimpleMenuItem(
            label: l10n.fullScreen,
            onPressedWithContext: _handleFullScreen,
          ),
        ],
      ),
      SimpleMenuItem(
        label: l10n.help,
        children: [
          SimpleMenuItem(
            label: l10n.documentation,
            onPressedWithContext: _handleDocumentation,
          ),
          SimpleMenuItem(
            label: l10n.about,
            onPressedWithContext: _handleAbout,
          ),
        ],
      ),
    ];

    if (Platform.environment['ENABLE_PLUGINS'] == 'true') {
      menus.add(
        SimpleMenuItem(
          label: l10n.plugins,
          children: _buildPluginMenuItems(context),
        ),
      );
    }

    menuRegistry.registerMenus(menus);

    debugPrint('✅ Re-registered ${menuRegistry.menus.length} menus');

    // Force rebuild of the widget tree to update menu display
    if (mounted) {
      // Refresh titles of any open settings tabs so they reflect the new locale
      try {
        ref.read(tabProvider.notifier).updateTabTitles((tab) {
          if (tab.contentType == 'settings') {
            // Map id to localized title where possible
            switch (tab.id) {
              case 'settings':
                return l10n.settings;
              case 'settings:appearance':
                return l10n.appearance;
              case 'settings:interface':
                return l10n.interface;
              case 'settings:general':
                return l10n.general;
              case 'settings:about':
                return l10n.about;
              default:
                return tab.title;
            }
          }
          return tab.title;
        });
      } catch (_) {
        // If tabProvider isn't available for some reason, ignore and continue
      }

      setState(() {});
      debugPrint('🔄 Forced widget rebuild');
    }
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
      _registerSearchFeature();
      _registerSettingsFeature();
      _registerPluginFeature();
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
    // Register settings sidebar item and content providers
    // final registry = UIRegistry();
    UIRegistry()
      ..registerSidebarItem(settingsItem)
      ..registerSidebarItem(settingsItem)
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

  void _registerPluginFeature() {
    // Plugin sidebar items are now registered after UI is built
    // in _registerPluginSidebarItems()
  }

  /// Register plugin sidebar items after UI is built
  void _registerPluginSidebarItems() {
    try {
      final pluginManager = PluginManager.instance;
      final activePlugins = pluginManager.getActivePlugins();
      final registry = UIRegistry();

      if (activePlugins.isNotEmpty) {
        debugPrint('Registering ${activePlugins.length} plugin sidebar items');

        for (final plugin in activePlugins) {
          final sidebarItem = IndividualPluginSidebarItem(plugin);
          registry.registerSidebarItem(sidebarItem);
          debugPrint('Registered sidebar item for plugin: ${plugin.name}');
        }
      } else {
        debugPrint('No active plugins found to register');
      }
    } catch (e) {
      debugPrint('Failed to register plugin sidebar items: $e');
    }
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context).openFolderFirst,
          ),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context).noFileOpenToSave,
          ),
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
        content: Text(
          AppLocalizations.of(context)
              .fileSaved(editorState.filePath!.split('/').last),
        ),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context).noContentToExport,
          ),
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
        title: Text(
          AppLocalizations.of(context).exitApplication,
        ),
        content: Text(
          AppLocalizations.of(context).confirmExit,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
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
              }
            },
            child: Text(
              AppLocalizations.of(context).exit,
            ),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context).nothingToUndo,
          ),
        ),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context).nothingToRedo,
          ),
        ),
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context).contentCutToClipboard,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).noContentToCut,
            ),
          ),
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context).contentCopiedToClipboard,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).noContentToCopy,
            ),
          ),
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context).contentPastedFromClipboard,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).noTextInClipboard,
            ),
          ),
        );
      }
    }
  }

  void _handleToggleSidebar(BuildContext context) {
    ref.read(uiStateProvider.notifier).toggleSidebar();
  }

  void _handleTogglePanel(BuildContext context) {
    final uiState = ref.read(uiStateProvider);
    final uiNotifier = ref.read(uiStateProvider.notifier);
    if (uiState.isSidePanelVisible) {
      uiNotifier.hideSidePanel();
    } else {
      // Show side panel if there's a selected item, otherwise show a message
      if (uiState.selectedSidebarItem != null) {
        uiNotifier.showSidePanel();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).selectSidebarItemFirst,
            ),
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
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.loomDocumentation,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcomeToLoom,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.loomDescriptionFull,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.keyFeatures,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              l10n.fileExplorerFeature,
            ),
            Text(
              l10n.richTextEditorFeature,
            ),
            Text(
              l10n.searchFeature,
            ),
            Text(
              l10n.settingsFeature,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.keyboardShortcuts,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              l10n.saveShortcut,
            ),
            Text(
              l10n.globalSearchShortcut,
            ),
            Text(
              l10n.undoShortcut,
            ),
            Text(
              l10n.redoShortcut,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.close,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAbout(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Loom',
        applicationVersion: '1.0.0',
        applicationLegalese: '© 2025 Loom Team',
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.loomDescriptionFull,
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
        title: Text(
          AppLocalizations.of(context).newFile,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).fileName,
            hintText: AppLocalizations.of(context).enterFileName,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
          ),
          TextButton(
            onPressed: () async {
              final fileName = controller.text.trim();

              if (fileName.isNotEmpty && workspace != null) {
                // Input validation
                if (fileName.isEmpty || fileName.length > 255) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context).invalidFileName,
                      ),
                    ),
                  );
                  return;
                }

                // Prevent directory traversal
                if (fileName.contains('..') ||
                    fileName.contains('/') ||
                    fileName.contains(r'\')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)
                            .invalidCharactersInFileName,
                      ),
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
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).fileCreated(fileName),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                              .failedToCreateFile(e.toString()),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(
              AppLocalizations.of(context).create,
            ),
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
        title: Text(
          AppLocalizations.of(context).exportFile,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fileNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).fileName,
                hintText: AppLocalizations.of(context).enterFileName,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: AppLocalizations.of(context).enterExportLocation,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: formatController,
              decoration: InputDecoration(
                labelText: 'Format',
                hintText: AppLocalizations.of(context).formatHint,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
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
                        content: Text(
                          AppLocalizations.of(context)
                              .fileExportedAs('$fileName.$format'),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                              .failedToExportFile(e.toString()),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(
              AppLocalizations.of(context).export,
            ),
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
        title: Text(AppLocalizations.of(context).saveAs),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fileNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).fileName,
                hintText: AppLocalizations.of(context).enterFileName,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                hintText: AppLocalizations.of(context).enterSaveLocation,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
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
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).fileSavedAs(fileName),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                              .failedToSaveFile(e.toString()),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(
              AppLocalizations.of(context).save,
            ),
          ),
        ],
      ),
    );
  }

  /// Show plugin manager dialog
  void _showPluginManager(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const PluginManagerDialog(),
    );
  }

  /// Build plugin menu items dynamically
  List<MenuItem> _buildPluginMenuItems(BuildContext context) {
    final pluginManager = PluginManager.instance;
    final activePlugins = pluginManager.getActivePlugins();
    final menuItems = <MenuItem>[];
    final l10n = AppLocalizations.of(context);

    // Add plugin management items
    menuItems
      ..add(
        SimpleMenuItem(
          label: l10n.pluginManager,
          icon: Icons.extension,
          onPressedWithContext: _showPluginManager,
        ),
      )
      ..add(const SimpleMenuItem(label: '-')); // Separator

    // Add menu items for each active plugin
    for (final plugin in activePlugins) {
      final pluginCommands = plugin.capabilities.commands;
      if (pluginCommands.isNotEmpty) {
        final commandItems = pluginCommands.map((command) {
          return SimpleMenuItem(
            label: _formatCommandLabel(command),
            icon: _getCommandIcon(command),
            onPressedWithContext: (context) => _executePluginCommand(
              context,
              plugin.id,
              command,
            ),
          );
        }).toList();

        menuItems.add(
          SimpleMenuItem(
            label: plugin.name,
            icon: Icons.extension,
            children: commandItems,
          ),
        );
      }
    }

    // If no plugins are loaded, show a message
    if (activePlugins.isEmpty) {
      menuItems.add(
        SimpleMenuItem(
          label: l10n.noPluginsLoaded,
          icon: Icons.info,
          onPressedWithContext: (context) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.noPluginsCurrentlyLoaded,
                ),
              ),
            );
          },
        ),
      );
    }

    return menuItems;
  }

  /// Format command name for display
  String _formatCommandLabel(String command) {
    // Convert command names like 'git.status' to 'Status'
    final parts = command.split('.');
    if (parts.length > 1) {
      return parts.last.replaceAll('_', ' ').toUpperCase();
    }
    return command.replaceAll('_', ' ').toUpperCase();
  }

  /// Get appropriate icon for command
  IconData _getCommandIcon(String command) {
    if (command.contains('git')) {
      return Icons.code;
    } else if (command.contains('hello') || command.contains('greet')) {
      return Icons.waving_hand;
    } else if (command.contains('status')) {
      return Icons.info;
    } else if (command.contains('commit')) {
      return Icons.save;
    } else if (command.contains('push')) {
      return Icons.upload;
    } else if (command.contains('pull')) {
      return Icons.download;
    }
    return Icons.play_arrow;
  }

  /// Execute a plugin command
  Future<void> _executePluginCommand(
    BuildContext context,
    String pluginId,
    String commandId,
  ) async {
    try {
      final pluginManager = PluginManager.instance;
      final result = await pluginManager.executeCommand(
        pluginId,
        commandId,
        <String, dynamic>{},
      );

      if (result.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).commandExecutedSuccessfully,
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)
                    .commandFailed(result.error ?? 'Unknown error'),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).failedToExecuteCommand(e.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(uiStateProvider);
    final appearanceSettings = ref.watch(appearanceSettingsProvider);
    final compactMode = appearanceSettings.compactMode;

    // Watch for locale changes and re-register menus when it changes
    final currentLocale = ref.watch(localeProvider);
    if (_currentLocale != currentLocale) {
      final previousLocale = _currentLocale;
      _currentLocale = currentLocale;

      // Only re-register if this is not the initial load
      if (previousLocale != null && _isInitialized) {
        debugPrint(
          '🌍 Locale changed from ${previousLocale.languageCode} to ${currentLocale.languageCode}',
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _reRegisterMenus();
        });
      } else {
        debugPrint('🌍 Initial locale set to ${currentLocale.languageCode}');
      }
    }

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
              height: AdaptiveConstants.topBarHeight(
                context,
                compactMode: compactMode,
              ),
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
                    width: uiState.isSidePanelVisible
                        ? () {
                            final width = AdaptiveConstants.sidePanelWidth(
                              context,
                              compactMode: compactMode,
                            );
                            debugPrint(
                              'Side panel width: $width, visible: ${uiState.isSidePanelVisible}',
                            );
                            return width;
                          }()
                        : 0,
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

/// Plugin Manager Dialog
class PluginManagerDialog extends ConsumerWidget {
  const PluginManagerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pluginManager = PluginManager.instance;
    final installedPlugins = pluginManager.getInstalledPlugins();
    final activePlugins = pluginManager.getActivePlugins();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).pluginManager,
      ),
      content: SizedBox(
        width: 600,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: AppLocalizations.of(context).installed,
                      value: installedPlugins.length.toString(),
                      icon: Icons.inventory,
                    ),
                    _StatItem(
                      label: AppLocalizations.of(context).active,
                      value: activePlugins.length.toString(),
                      icon: Icons.play_arrow,
                    ),
                    _StatItem(
                      label: AppLocalizations.of(context).inactive,
                      value: (installedPlugins.length - activePlugins.length)
                          .toString(),
                      icon: Icons.stop,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Plugin list
            Expanded(
              child: ListView.builder(
                itemCount: installedPlugins.length,
                itemBuilder: (context, index) {
                  final plugin = installedPlugins[index];
                  final isActive = activePlugins.any((p) => p.id == plugin.id);
                  final state = pluginManager.getPluginState(plugin.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        isActive
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isActive ? Colors.green : Colors.grey,
                      ),
                      title: Text(plugin.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plugin.description),
                          Text(
                            l10n.versionState(plugin.version, state.name),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (plugin.capabilities.commands.isNotEmpty)
                            Chip(
                              label: Text(
                                l10n.commandsCount(
                                  plugin.capabilities.commands.length,
                                ),
                              ),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon:
                                Icon(isActive ? Icons.stop : Icons.play_arrow),
                            onPressed: () async {
                              try {
                                if (isActive) {
                                  await pluginManager.disablePlugin(plugin.id);
                                } else {
                                  await pluginManager.enablePlugin(plugin.id);
                                }
                                // Force rebuild
                                (context as Element).markNeedsBuild();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isActive
                                            ? AppLocalizations.of(context)
                                                .failedToDisablePlugin(
                                                e.toString(),
                                              )
                                            : AppLocalizations.of(context)
                                                .failedToEnablePlugin(
                                                e.toString(),
                                              ),
                                      ),
                                      backgroundColor: theme.colorScheme.error,
                                    ),
                                  );
                                }
                              }
                            },
                            tooltip: isActive
                                ? AppLocalizations.of(context).disablePlugin
                                : AppLocalizations.of(context).enablePlugin,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context).close,
          ),
        ),
      ],
    );
  }
}

/// Statistics item widget
class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 32, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
