import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/settings/presentation/providers/top_bar_settings_provider.dart';
import 'package:loom/features/settings/presentation/providers/window_controls_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/menu_system.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/top_bar_registry.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/window_controls.dart';

/// Extensible top bar with registered items and window controls
class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final registry = TopBarRegistry();
    final windowSettings = ref.watch(windowControlsSettingsProvider);
    final topBarSettings = ref.watch(topBarSettingsProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: _buildTopBarContent(
        context,
        registry,
        windowSettings,
        topBarSettings,
      ),
    );
  }

  Widget _buildTopBarContent(
    BuildContext context,
    TopBarRegistry registry,
    WindowControlsSettings windowSettings,
    TopBarSettings topBarSettings,
  ) {
    final leftItems = registry.getItemsByPosition(TopBarPosition.left);
    final centerItems = registry.getItemsByPosition(TopBarPosition.center);
    final rightItems = registry.getItemsByPosition(TopBarPosition.right);
    final placement = windowSettings.effectivePlacement;

    // Calculate available space for responsive behavior
    final screenWidth = MediaQuery.of(context).size.width;
    final windowControlsWidth = windowSettings.showControls ? 100.0 : 0.0;
    const searchBarWidth = 300.0;
    final titleWidth = topBarSettings.showTitle ? 150.0 : 0.0;
    const menuMinWidth = 200.0; // Minimum space needed for full menu

    // Calculate space occupied by window controls based on placement
    final leftControlsWidth =
        placement == WindowControlsPlacement.left && windowSettings.showControls
            ? windowControlsWidth
            : 0.0;
    final rightControlsWidth = placement == WindowControlsPlacement.right &&
            windowSettings.showControls
        ? windowControlsWidth
        : 0.0;

    // Total space taken by fixed elements (controls + search + title)
    final fixedElementsWidth = leftControlsWidth +
        rightControlsWidth +
        (topBarSettings.showSearch ? searchBarWidth : 0.0) +
        titleWidth;

    // Available space for menu
    final availableSpaceForMenu = screenWidth - fixedElementsWidth;

    // Determine if we should use hamburger menu based on actual available space
    final shouldUseHamburger = topBarSettings.showMenuAsHamburger ||
        availableSpaceForMenu < menuMinWidth;

    if (Platform.isMacOS) {
      return _buildMacOSLayout(
        context,
        registry,
        windowSettings,
        topBarSettings,
        shouldUseHamburger,
        leftItems,
        centerItems,
        rightItems,
        placement,
      );
    } else {
      return _buildDefaultLayout(
        context,
        registry,
        windowSettings,
        topBarSettings,
        shouldUseHamburger,
        leftItems,
        centerItems,
        rightItems,
        placement,
      );
    }
  }

  Widget _buildMacOSLayout(
    BuildContext context,
    TopBarRegistry registry,
    WindowControlsSettings windowSettings,
    TopBarSettings topBarSettings,
    bool shouldUseHamburger,
    List<TopBarItem> leftItems,
    List<TopBarItem> centerItems,
    List<TopBarItem> rightItems,
    WindowControlsPlacement placement,
  ) {
    return Stack(
      children: [
        // Absolutely centered search bar (unaffected by other components)
        if (topBarSettings.showSearch)
          Center(
            child: _buildSearchBar(context),
          ),

        // Left and right components positioned normally
        Row(
          children: [
            // Left side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Window controls (if on left and enabled)
                if (placement == WindowControlsPlacement.left &&
                    windowSettings.showControls)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: WindowControls(
                      placement: WindowControlsPlacement.left,
                      order: windowSettings.effectiveOrder,
                    ),
                  ),

                // Menu bar or hamburger
                if (shouldUseHamburger)
                  _buildHamburgerMenu(context)
                else
                  DesktopMenuBar(settings: topBarSettings),

                // App title (if enabled)
                if (topBarSettings.showTitle)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      topBarSettings.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                // Left items
                ...leftItems.map((item) => item.build(context)),
              ],
            ),

            // Spacer to push right items to the right
            const Spacer(),

            // Right side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Right items
                ...rightItems.map((item) => item.build(context)),

                // Window controls (if on right and enabled)
                if (placement == WindowControlsPlacement.right &&
                    windowSettings.showControls)
                  WindowControls(
                    order: windowSettings.effectiveOrder,
                  ),
              ],
            ),
          ],
        ),

        // Center items positioned separately (if any)
        if (centerItems.isNotEmpty && !topBarSettings.showSearch)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: centerItems.map((item) => item.build(context)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultLayout(
    BuildContext context,
    TopBarRegistry registry,
    WindowControlsSettings windowSettings,
    TopBarSettings topBarSettings,
    bool shouldUseHamburger,
    List<TopBarItem> leftItems,
    List<TopBarItem> centerItems,
    List<TopBarItem> rightItems,
    WindowControlsPlacement placement,
  ) {
    return Stack(
      children: [
        // Absolutely centered search bar (unaffected by other components)
        if (topBarSettings.showSearch)
          Center(
            child: _buildSearchBar(context),
          ),

        // Left and right components positioned normally
        Row(
          children: [
            // Left side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Window controls (if on left and enabled)
                if (placement == WindowControlsPlacement.left &&
                    windowSettings.showControls)
                  WindowControls(
                    placement: WindowControlsPlacement.left,
                    order: windowSettings.effectiveOrder,
                  ),

                // Menu bar or hamburger
                if (shouldUseHamburger)
                  _buildHamburgerMenu(context)
                else
                  DesktopMenuBar(settings: topBarSettings),

                // App title (if enabled)
                if (topBarSettings.showTitle)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      topBarSettings.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                // Left items
                ...leftItems.map((item) => item.build(context)),
              ],
            ),

            // Spacer to push right items to the right
            const Spacer(),

            // Right side
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Right items
                ...rightItems.map((item) => item.build(context)),

                // Window controls (if on right and enabled)
                if (placement == WindowControlsPlacement.right &&
                    windowSettings.showControls)
                  WindowControls(
                    order: windowSettings.effectiveOrder,
                  ),
              ],
            ),
          ],
        ),

        // Center items positioned separately (if any)
        if (centerItems.isNotEmpty && !topBarSettings.showSearch)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: centerItems.map((item) => item.build(context)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Make search bar responsive - smaller on narrow screens
    final searchBarWidth = screenWidth < 800 ? 200.0 : 300.0;

    return Container(
      width: searchBarWidth,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),
          Icon(
            Icons.search,
            size: 12,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHamburgerMenu(BuildContext context) {
    final theme = Theme.of(context);
    final menuRegistry = MenuRegistry();

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.menu,
        color: theme.colorScheme.onSurface,
      ),
      tooltip: 'Menu',
      itemBuilder: (BuildContext context) {
        return menuRegistry.menus
            .expand((menu) => _buildMenuItems(context, menu))
            .toList();
      },
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(
    BuildContext context,
    MenuItem menu,
  ) {
    final items = <PopupMenuEntry<String>>[];

    if (menu.children != null && menu.children!.isNotEmpty) {
      // Add header for this menu section
      items.add(
        PopupMenuItem<String>(
          enabled: false,
          child: Text(
            menu.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      );

      // Add children
      for (final child in menu.children!) {
        items.add(
          PopupMenuItem<String>(
            value: '${menu.label}_${child.label}',
            onTap: child.onPressed,
            child: Row(
              children: [
                if (child.icon != null) ...[
                  Icon(child.icon, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(child.label),
              ],
            ),
          ),
        );
      }

      // Add divider after each menu section (except last)
      items.add(const PopupMenuDivider());
    }

    return items;
  }
}
