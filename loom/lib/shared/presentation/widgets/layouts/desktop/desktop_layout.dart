import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/core/utils/platform_utils.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'navigation/top_bar.dart';
import 'navigation/sidebar.dart';
import 'panels/side_panel.dart';
import 'panels/content_area.dart';
import 'navigation/bottom_bar.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';

/// Desktop-specific layout with VSCode-inspired UI
/// - Fixed top bar with menu and search
/// - Icon-based sidebar (activity bar)
/// - Collapsible side panels
/// - Main content area with tabs
/// - Status bar at bottom
class DesktopLayout extends ConsumerWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(uiStateProvider);

    return Scaffold(
      body: Column(
        children: [
          // Top bar with menu and window controls
          SizedBox(
            height: AdaptiveConstants.topBarHeight(context),
            child: const TopBar(),
          ),

          // Main content area
          Expanded(
            child: Row(
              children: [
                // Sidebar (icon buttons) - always collapsed on desktop for clean look
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: AppTheme.sidebarCollapsedWidth,
                  child: const Sidebar(),
                ),

                // Side panel (expandable content)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: uiState.isSidePanelVisible
                      ? AdaptiveConstants.sidePanelWidth(context)
                      : 0,
                  child: uiState.isSidePanelVisible
                      ? SidePanel(
                          selectedItem: uiState.selectedSidebarItem,
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

                // Main content area
                Expanded(
                  child: ContentArea(
                    openedFile: uiState.openedFile,
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar (status bar)
          SizedBox(
            height: AppTheme.bottomBarHeight,
            child: const BottomBar(),
          ),
        ],
      ),
    );
  }
}
