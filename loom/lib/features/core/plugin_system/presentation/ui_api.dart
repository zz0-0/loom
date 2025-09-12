import 'package:flutter/material.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/bottom_bar_registry.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/menu_system.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/top_bar_registry.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/ui_registry.dart';
import 'package:loom/features/core/plugin_system/domain/plugin.dart';

/// UI API for plugins to register UI components
class PluginUIApi {
  PluginUIApi(this._registry);
  final PluginRegistry _registry;

  /// Register a sidebar item
  void registerSidebarItem(String pluginId, SidebarItem item) {
    // Register with the main UI registry
    UIRegistry().registerSidebarItem(item);

    // Track ownership in plugin registry
    _registry.registerComponent(pluginId, item.id);
  }

  /// Register a content provider
  void registerContentProvider(String pluginId, ContentProvider provider) {
    // Register with the main UI registry
    UIRegistry().registerContentProvider(provider);

    // Track ownership in plugin registry
    _registry.registerComponent(pluginId, provider.id);
  }

  /// Register a menu item
  void registerMenuItem(String pluginId, MenuItem item) {
    // Register with the main menu registry
    MenuRegistry().registerMenu(item);

    // Track ownership in plugin registry
    _registry.registerComponent(pluginId, item.label);
  }

  /// Register a bottom bar item
  void registerBottomBarItem(String pluginId, BottomBarItem item) {
    // Register with the main bottom bar registry
    BottomBarRegistry().registerItem(item);

    // Track ownership in plugin registry
    _registry.registerComponent(pluginId, item.id);
  }

  /// Register a top bar item
  void registerTopBarItem(String pluginId, TopBarItem item) {
    // Register with the main top bar registry
    TopBarRegistry().registerItem(item);

    // Track ownership in plugin registry
    _registry.registerComponent(pluginId, item.id);
  }

  /// Unregister all UI components for a plugin
  void unregisterPluginUI(String pluginId) {
    // Note: Current registries don't support component removal
    // This is a placeholder for future implementation when registries
    // add removal methods

    // Clear from plugin registry
    // Since we can't modify the returned list directly, we need to
    // clear components through the registry's internal methods
    // For now, this is handled by the plugin manager when unregistering
  }
}

/// Enhanced sidebar item with plugin ownership
abstract class PluginSidebarItem implements SidebarItem {
  String get pluginId;
}

/// Enhanced content provider with plugin ownership
abstract class PluginContentProvider implements ContentProvider {
  String get pluginId;
}

/// Enhanced menu item with plugin ownership
abstract class PluginMenuItem implements MenuItem {
  String get pluginId;
}

/// Enhanced bottom bar item with plugin ownership
abstract class PluginBottomBarItem implements BottomBarItem {
  String get pluginId;
}

/// Enhanced top bar item with plugin ownership
abstract class PluginTopBarItem implements TopBarItem {
  String get pluginId;
}

/// Plugin-specific UI components factory
class PluginUIComponents {
  /// Create a sidebar item for a plugin
  static PluginSidebarItem createSidebarItem({
    required String pluginId,
    required String id,
    required IconData icon,
    String? tooltip,
    Widget? Function(BuildContext)? buildPanel,
    VoidCallback? onPressed,
  }) {
    return _PluginSidebarItem(
      pluginId: pluginId,
      id: id,
      icon: icon,
      tooltip: tooltip,
      buildPanel: buildPanel,
      onPressed: onPressed,
    );
  }

  /// Create a content provider for a plugin
  static PluginContentProvider createContentProvider({
    required String pluginId,
    required String id,
    required Widget Function(BuildContext) build,
    required bool Function(String?) canHandle,
  }) {
    return _PluginContentProvider(
      pluginId: pluginId,
      id: id,
      build: build,
      canHandle: canHandle,
    );
  }

  /// Create a menu item for a plugin
  static PluginMenuItem createMenuItem({
    required String pluginId,
    required String label,
    List<MenuItem>? children,
    VoidCallback? onPressed,
    void Function(BuildContext)? onPressedWithContext,
    IconData? icon,
  }) {
    return _PluginMenuItem(
      pluginId: pluginId,
      label: label,
      children: children,
      onPressed: onPressed,
      onPressedWithContext: onPressedWithContext,
      icon: icon,
    );
  }
}

/// Implementation of plugin sidebar item
class _PluginSidebarItem implements PluginSidebarItem {
  const _PluginSidebarItem({
    required this.pluginId,
    required this.id,
    required this.icon,
    this.tooltip,
    Widget? Function(BuildContext)? buildPanel,
    this.onPressed,
  }) : _buildPanel = buildPanel;

  @override
  final String pluginId;

  @override
  final String id;

  @override
  final IconData icon;

  @override
  final String? tooltip;

  @override
  Widget? buildPanel(BuildContext context) {
    return _buildPanel?.call(context);
  }

  final Widget? Function(BuildContext)? _buildPanel;

  @override
  final VoidCallback? onPressed;
}

/// Implementation of plugin content provider
class _PluginContentProvider implements PluginContentProvider {
  const _PluginContentProvider({
    required this.pluginId,
    required this.id,
    required Widget Function(BuildContext) build,
    required bool Function(String?) canHandle,
  })  : _build = build,
        _canHandle = canHandle;

  @override
  final String pluginId;

  @override
  final String id;

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  final Widget Function(BuildContext) _build;

  @override
  bool canHandle(String? contentId) {
    return _canHandle(contentId);
  }

  final bool Function(String?) _canHandle;
}

/// Implementation of plugin menu item
class _PluginMenuItem implements PluginMenuItem {
  const _PluginMenuItem({
    required this.pluginId,
    required this.label,
    this.children,
    this.onPressed,
    this.onPressedWithContext,
    this.icon,
  });

  @override
  final String pluginId;

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
