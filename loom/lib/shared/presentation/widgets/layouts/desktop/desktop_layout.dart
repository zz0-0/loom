import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/core/utils/platform_utils.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/content/settings_content.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/bottom_bar_registry.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/extensible_content_area.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/extensible_side_panel.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/extensible_sidebar.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/menu_system.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/examples/example_feature_registration.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/items/settings_sidebar_item.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/navigation/bottom_bar.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/navigation/top_bar.dart';

/// Extensible desktop layout with customizable UI components
/// This serves as the main UI scaffold that features can register into
class DesktopLayout extends ConsumerStatefulWidget {
  const DesktopLayout({super.key});

  @override
  ConsumerState<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<DesktopLayout> {
  @override
  void initState() {
    super.initState();
    _registerDefaultComponents();
  }

  /// Register default UI components
  void _registerDefaultComponents() {
    final uiRegistry = UIRegistry();
    final bottomBarRegistry = BottomBarRegistry();
    final menuRegistry = MenuRegistry();

    // Register example features (demonstrating the extensible system)
    ExampleFeatureRegistration.register();

    // Register the settings sidebar item and content
    uiRegistry
      ..registerSidebarItem(SettingsSidebarItem())
      ..registerContentProvider(SettingsContentProvider())
      ..registerContentProvider(AppearanceSettingsContentProvider())
      ..registerContentProvider(InterfaceSettingsContentProvider())
      ..registerContentProvider(GeneralSettingsContentProvider())
      ..registerContentProvider(AboutSettingsContentProvider());

    // Register default menus
    menuRegistry.registerMenus([
      SimpleMenuItem(
        label: 'File',
        children: [
          SimpleMenuItem(label: 'New', icon: Icons.add, onPressed: () {}),
          SimpleMenuItem(
            label: 'Open',
            icon: Icons.folder_open,
            onPressed: () {},
          ),
          SimpleMenuItem(label: 'Save', icon: Icons.save, onPressed: () {}),
          SimpleMenuItem(label: 'Save As...', onPressed: () {}),
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

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(uiStateProvider);

    return Scaffold(
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
                            ref.read(uiStateProvider.notifier).hideSidePanel();
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
    );
  }
}
