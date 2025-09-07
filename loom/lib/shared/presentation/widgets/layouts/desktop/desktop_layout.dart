import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/core/utils/platform_utils.dart';
import 'package:loom/features/explorer/presentation/items/explorer_sidebar_item.dart';
import 'package:loom/features/plugin_system/domain/plugin_bootstrapper.dart';
import 'package:loom/features/settings/presentation/widgets/settings_content.dart';
import 'package:loom/features/settings/presentation/widgets/settings_sidebar_item.dart';
import 'package:loom/shared/presentation/providers/directory_operations_provider.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';
import 'package:loom/shared/presentation/widgets/dialogs/folder_browser_dialog.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/bottom_bar_registry.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/extensible_content_area.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/extensible_side_panel.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/extensible_sidebar.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/file_content_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/menu_system.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/navigation/bottom_bar.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/navigation/top_bar.dart';

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
    final bottomBarRegistry = BottomBarRegistry();
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
          SimpleMenuItem(label: 'New', icon: Icons.add, onPressed: () {}),
          SimpleMenuItem(
            label: 'Open',
            icon: Icons.folder_open,
            onPressedWithContext: (context) =>
                _showOpenFolderDialog(context, ref),
          ),
          SimpleMenuItem(label: 'Save', icon: Icons.save, onPressed: () {}),
          SimpleMenuItem(label: 'Save As...', onPressed: () {}),
          SimpleMenuItem(
            label: 'Export',
            icon: Icons.file_download,
            onPressedWithContext: _showExportDialog,
          ),
          SimpleMenuItem(label: 'Exit', onPressed: () {}),
        ],
      ),
      SimpleMenuItem(
        label: 'Edit',
        children: [
          SimpleMenuItem(label: 'Undo', icon: Icons.undo, onPressed: () {}),
          SimpleMenuItem(label: 'Redo', icon: Icons.redo, onPressed: () {}),
          SimpleMenuItem(
            label: 'Cut',
            icon: Icons.content_cut,
            onPressed: () {},
          ),
          SimpleMenuItem(label: 'Copy', icon: Icons.copy, onPressed: () {}),
          SimpleMenuItem(label: 'Paste', icon: Icons.paste, onPressed: () {}),
        ],
      ),
      SimpleMenuItem(
        label: 'View',
        children: [
          SimpleMenuItem(label: 'Toggle Sidebar', onPressed: () {}),
          SimpleMenuItem(label: 'Toggle Panel', onPressed: () {}),
          SimpleMenuItem(label: 'Full Screen', onPressed: () {}),
        ],
      ),
      SimpleMenuItem(
        label: 'Help',
        children: [
          SimpleMenuItem(label: 'Documentation', onPressed: () {}),
          SimpleMenuItem(label: 'About', onPressed: () {}),
        ],
      ),
    ]);

    // Register default bottom bar items
    bottomBarRegistry.registerItems([
      StatusBottomBarItem(),
      LanguageBottomBarItem(),
      EncodingBottomBarItem(),
      LineEndingBottomBarItem(),
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
      _registerExportFeature();
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
    // TODO(user): Register search feature when implemented
  }

  void _registerExportFeature() {
    // TODO(user): Register export feature when implemented
  }

  void _showGlobalSearchDialog(BuildContext context) {
    // TODO(user): Implement global search dialog
  }

  void _showExportDialog(BuildContext context) {
    // TODO(user): Implement export dialog
  }

  Future<void> _showOpenFolderDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // Try to use file_picker to select directory
      var selectedDirectory = await FilePicker.platform.getDirectoryPath();

      // If FilePicker didn't work or returned null, show the shared folder browser
      if (selectedDirectory == null || selectedDirectory.isEmpty) {
        if (!context.mounted) return;
        selectedDirectory = await showDialog<String>(
          context: context,
          builder: (context) => const FolderBrowserDialog(
            initialPath: '/workspaces',
          ),
        );
      }

      if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
        final directoryOps = ref.read(directoryOperationsProvider.notifier);
        await directoryOps.validateDirectory(selectedDirectory);
        final state = ref.read(directoryOperationsProvider);

        if (state.error != null) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot access directory: ${state.error}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }

        // TODO(user): Implement workspace opening
        // await ref
        //     .read(currentWorkspaceProvider.notifier)
        //     .openWorkspace(selectedDirectory);
      } else {
        // No directory selected
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No directory selected'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open folder: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
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
          // Export shortcut (Ctrl+E)
          if (HardwareKeyboard.instance.isControlPressed &&
              event.logicalKey == LogicalKeyboardKey.keyE) {
            _showExportDialog(context);
            return KeyEventResult.handled;
          }
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
                    width: AppTheme.sidebarCollapsedWidth,
                    child: const ExtensibleSidebar(),
                  ),

                  // Extensible side panel
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: uiState.isSidePanelVisible
                        ? AdaptiveConstants.sidePanelWidth(context)
                        : 0,
                    child: uiState.isSidePanelVisible
                        ? ExtensibleSidePanel(
                            selectedItemId: uiState.selectedSidebarItem,
                            onClose: () {
                              ref
                                  .read(uiStateProvider.notifier)
                                  .hideSidePanel();
                            },
                          )
                        : null,
                  ),

                  // Vertical divider
                  if (uiState.isSidePanelVisible)
                    Container(
                      width: 1,
                      color: Theme.of(context).dividerColor,
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
