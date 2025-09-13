import 'package:loom/features/core/plugin_system/index.dart';

/// Handles plugin events
class PluginEventManager {
  factory PluginEventManager() => _instance;

  PluginEventManager._internal();
  static final PluginEventManager _instance = PluginEventManager._internal();

  final Map<String, Plugin> _loadedPlugins = {};
  final Map<String, PluginState> _pluginStates = {};

  /// Update the internal state (called by lifecycle manager)
  void updateState(
    Map<String, Plugin> plugins,
    Map<String, PluginState> states,
  ) {
    _loadedPlugins
      ..clear()
      ..addAll(plugins);
    _pluginStates
      ..clear()
      ..addAll(states);
  }

  /// Handle file open event for all plugins
  void onFileOpen(String path) {
    for (final plugin in _loadedPlugins.values) {
      if (_pluginStates[plugin.id] == PluginState.active) {
        plugin.onFileOpen(path);
      }
    }
  }

  /// Handle workspace change event for all plugins
  void onWorkspaceChange(String workspacePath) {
    for (final plugin in _loadedPlugins.values) {
      if (_pluginStates[plugin.id] == PluginState.active) {
        plugin.onWorkspaceChange(workspacePath);
      }
    }
  }
}
