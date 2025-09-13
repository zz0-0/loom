import 'package:loom/features/core/plugin_system/domain/entities/plugin_base.dart';

/// Registry for plugin components
class PluginRegistry {
  final Map<String, Plugin> _plugins = {};
  final Map<String, List<String>> _pluginComponents = {};

  /// Register a plugin
  void registerPlugin(Plugin plugin) {
    _plugins[plugin.id] = plugin;
    _pluginComponents[plugin.id] = [];
  }

  /// Unregister a plugin and all its components
  void unregisterPlugin(String pluginId) {
    _plugins.remove(pluginId);
    _pluginComponents.remove(pluginId);
  }

  /// Register a component for a plugin
  void registerComponent(String pluginId, String componentId) {
    _pluginComponents[pluginId]?.add(componentId);
  }

  /// Unregister a component from a plugin
  void unregisterComponent(String pluginId, String componentId) {
    _pluginComponents[pluginId]?.remove(componentId);
  }

  /// Get all registered plugins
  Map<String, Plugin> get plugins => Map.unmodifiable(_plugins);

  /// Get components registered by a plugin
  List<String> getPluginComponents(String pluginId) {
    return List.unmodifiable(_pluginComponents[pluginId] ?? []);
  }

  /// Check if a plugin is registered
  bool isPluginRegistered(String pluginId) {
    return _plugins.containsKey(pluginId);
  }
}
