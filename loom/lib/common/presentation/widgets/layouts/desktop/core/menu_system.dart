import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Interface for menu items
abstract class MenuItem {
  String get label;
  List<MenuItem>? get children;
  VoidCallback? get onPressed;
  void Function(BuildContext)? get onPressedWithContext;
  IconData? get icon;
}

/// Implementation of a simple menu item
class SimpleMenuItem implements MenuItem {
  const SimpleMenuItem({
    required this.label,
    this.children,
    this.onPressed,
    this.onPressedWithContext,
    this.icon,
  });

  @override
  final String label;

  @override
  final List<MenuItem>? children;

  @override
  final VoidCallback? onPressed;

  @override
  final void Function(BuildContext)? onPressedWithContext;

  @override
  final IconData? icon;
}

/// Settings for top bar appearance
class TopBarSettings {
  const TopBarSettings({
    this.showTitle = false,
    this.showSearch = true,
    this.showMenuAsHamburger = false,
    this.title = 'Loom',
  });

  final bool showTitle;
  final bool showSearch;
  final bool showMenuAsHamburger;
  final String title;

  TopBarSettings copyWith({
    bool? showTitle,
    bool? showSearch,
    bool? showMenuAsHamburger,
    String? title,
  }) {
    return TopBarSettings(
      showTitle: showTitle ?? this.showTitle,
      showSearch: showSearch ?? this.showSearch,
      showMenuAsHamburger: showMenuAsHamburger ?? this.showMenuAsHamburger,
      title: title ?? this.title,
    );
  }
}

/// Menu registry for top bar menus
class MenuRegistry {
  factory MenuRegistry() {
    debugPrint('🏭 MenuRegistry: Factory called, returning instance');
    return _instance;
  }
  MenuRegistry._internal() {
    debugPrint('🏗️ MenuRegistry: Internal constructor called');
  }
  static final MenuRegistry _instance = MenuRegistry._internal();

  final List<MenuItem> _menus = [];
  final ValueNotifier<List<MenuItem>> _menusNotifier = ValueNotifier([]);

  /// Register a menu
  void registerMenu(MenuItem menu) {
    _menus
      ..removeWhere((existing) => existing.label == menu.label)
      ..add(menu);
    debugPrint('📝 MenuRegistry: Registered menu "${menu.label}"');
    _notifyListeners();
  }

  /// Register multiple menus
  void registerMenus(List<MenuItem> menus) {
    for (final menu in menus) {
      registerMenu(menu);
    }
  }

  /// Get all registered menus
  List<MenuItem> get menus => List.unmodifiable(_menus);

  /// Get the notifier for menu changes
  ValueNotifier<List<MenuItem>> get menusNotifier => _menusNotifier;

  /// Clear all registrations
  void clear() {
    debugPrint('🗑️ MenuRegistry: Clearing ${_menus.length} menus');
    _menus.clear();
    _notifyListeners();
  }

  void _notifyListeners() {
    debugPrint(
        '📢 MenuRegistry: Notifying listeners with ${_menus.length} menus',);
    _menusNotifier.value = List.unmodifiable(_menus);
  }
}

/// Desktop-style menu widget
class DesktopMenuBar extends StatefulWidget {
  const DesktopMenuBar({
    required this.settings,
    super.key,
    this.onMenuPressed,
  });

  final TopBarSettings settings;
  final VoidCallback? onMenuPressed;

  @override
  State<DesktopMenuBar> createState() => _DesktopMenuBarState();
}

class _DesktopMenuBarState extends State<DesktopMenuBar> {
  late final MenuRegistry _registry;
  late final ValueNotifier<List<MenuItem>> _menusNotifier;
  List<MenuItem> _menus = [];

  @override
  void initState() {
    super.initState();
    _registry = MenuRegistry();
    _menusNotifier = _registry.menusNotifier;
    _menus = _registry.menus;
    _menusNotifier.addListener(_onMenusChanged);
  }

  @override
  void dispose() {
    _menusNotifier.removeListener(_onMenusChanged);
    super.dispose();
  }

  void _onMenusChanged() {
    debugPrint(
        '📡 DesktopMenuBar: Menus changed, rebuilding with ${MenuRegistry().menus.length} menus',);
    setState(() {
      _menus = _registry.menus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Watch locale changes to force rebuild when language changes
        ref.watch(localeProvider);

        if (widget.settings.showMenuAsHamburger || _menus.isEmpty) {
          // Show hamburger menu only if there are menus to show
          if (_menus.isEmpty) {
            return const SizedBox.shrink(); // Don't show hamburger if no menus
          }

          return IconButton(
            icon: const Icon(Icons.menu, size: 16),
            onPressed: widget.onMenuPressed ??
                () => _showHamburgerMenu(context, ref, _menus),
            splashRadius: 16,
          );
        } else {
          // Show desktop-style menu bar
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: _menus.map((menu) => _MenuBarItem(menu: menu)).toList(),
          );
        }
      },
    );
  }

  void _showHamburgerMenu(
    BuildContext context,
    WidgetRef ref,
    List<MenuItem> menus,
  ) {
    // Don't show menu if there are no items
    if (menus.isEmpty) {
      return;
    }

    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: _buildMenuItems(context, ref, menus),
    );
  }

  List<PopupMenuEntry<VoidCallback?>> _buildMenuItems(
    BuildContext context,
    WidgetRef ref,
    List<MenuItem> menus,
  ) {
    final appearanceSettings = ref.watch(appearanceSettingsProvider);
    final showIcons = appearanceSettings.showMenuIcons;
    final items = <PopupMenuEntry<VoidCallback?>>[];

    for (var i = 0; i < menus.length; i++) {
      final menu = menus[i];

      if (menu.children != null && menu.children!.isEmpty) {
        // Submenu
        items.add(
          PopupMenuItem<VoidCallback?>(
            child: Row(
              children: [
                if (showIcons && menu.icon != null) ...[
                  Icon(menu.icon, size: 16),
                  const SizedBox(width: 8),
                ],
                Expanded(child: Text(menu.label)),
                const Icon(Icons.arrow_right, size: 16),
              ],
            ),
          ),
        );
      } else {
        // Regular menu item
        items.add(
          PopupMenuItem<VoidCallback?>(
            value: () {
              menu.onPressedWithContext?.call(context);
              menu.onPressed?.call();
            },
            child: Row(
              children: [
                if (showIcons && menu.icon != null) ...[
                  Icon(menu.icon, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(menu.label),
              ],
            ),
          ),
        );
      }

      // Add divider if not last item
      if (i < menus.length - 1) {
        items.add(const PopupMenuDivider());
      }
    }

    return items;
  }
}

class _MenuBarItem extends ConsumerWidget {
  const _MenuBarItem({required this.menu});

  final MenuItem menu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearanceSettings = ref.watch(appearanceSettingsProvider);

    return _MenuBarItemStateful(
      menu: menu,
      appearanceSettings: appearanceSettings,
    );
  }
}

class _MenuBarItemStateful extends StatefulWidget {
  const _MenuBarItemStateful({
    required this.menu,
    required this.appearanceSettings,
  });

  final MenuItem menu;
  final AppearanceSettings appearanceSettings;

  @override
  State<_MenuBarItemStateful> createState() => _MenuBarItemStateState();
}

class _MenuBarItemStateState extends State<_MenuBarItemStateful> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: _isHovered
            ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.3)
            : Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.menu.onPressedWithContext != null) {
              widget.menu.onPressedWithContext!(context);
            } else if (widget.menu.onPressed != null) {
              widget.menu.onPressed!();
            } else {
              _showSubmenu(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.appearanceSettings.showMenuIcons &&
                    widget.menu.icon != null) ...[
                  Icon(widget.menu.icon, size: 14),
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.menu.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSubmenu(BuildContext context) {
    if (widget.menu.children == null || widget.menu.children!.isEmpty) return;

    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: widget.menu.children!
          .map(
            (item) => PopupMenuItem<VoidCallback?>(
              height: 32,
              value: () {
                item.onPressedWithContext?.call(context);
                item.onPressed?.call();
              },
              child: Row(
                children: [
                  if (widget.appearanceSettings.showMenuIcons &&
                      item.icon != null) ...[
                    Icon(item.icon, size: 14),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ).then((callback) {
      if (callback != null) {
        callback();
      }
    });
  }
}
