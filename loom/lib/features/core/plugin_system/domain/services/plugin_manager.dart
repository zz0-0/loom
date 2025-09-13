import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';

/// Manages the lifecycle of plugins
class PluginManager {
  factory PluginManager() => _instance;

  PluginManager._internal();
  static final PluginManager _instance = PluginManager._internal();

  final PluginLifecycleManager _lifecycleManager = PluginLifecycleManager();
  final PluginEventManager _eventManager = PluginEventManager();

  /// Initialize the plugin system
  Future<void> initialize() async {
    await _lifecycleManager.initialize();
    _updateEventManagerState();
  }

  /// Register a plugin
  Future<void> registerPlugin(Plugin plugin, BuildContext context) async {
    await _lifecycleManager.registerPlugin(plugin, context);
    _updateEventManagerState();
  }

  /// Unregister a plugin
  Future<void> unregisterPlugin(String pluginId) async {
    await _lifecycleManager.unregisterPlugin(pluginId);
    _updateEventManagerState();
  }

  /// Activate a plugin
  Future<void> activatePlugin(String pluginId) async {
    await _lifecycleManager.activatePlugin(pluginId);
    _updateEventManagerState();
  }

  /// Get a plugin by ID
  Plugin? getPlugin(String pluginId) {
    return _lifecycleManager.getPlugin(pluginId);
  }

  /// Get the state of a plugin
  PluginState getPluginState(String pluginId) {
    return _lifecycleManager.getPluginState(pluginId);
  }

  /// Get the context of a plugin
  PluginContext? getPluginContext(String pluginId) {
    return _lifecycleManager.getPluginContext(pluginId);
  }

  /// Get all loaded plugins
  Map<String, Plugin> get loadedPlugins => _lifecycleManager.loadedPlugins;

  /// Get all plugin states
  Map<String, PluginState> get pluginStates => _lifecycleManager.pluginStates;

  /// Get the plugin registry
  PluginRegistry get registry => _lifecycleManager.registry;

  /// Handle file open event for all plugins
  void onFileOpen(String path) {
    _eventManager.onFileOpen(path);
  }

  /// Handle workspace change event for all plugins
  void onWorkspaceChange(String workspacePath) {
    _eventManager.onWorkspaceChange(workspacePath);
  }

  /// Update the event manager with current state
  void _updateEventManagerState() {
    _eventManager.updateState(
      _lifecycleManager.loadedPlugins,
      _lifecycleManager.pluginStates,
    );
  }

  /// Dispose all plugins
  Future<void> dispose() async {
    for (final pluginId in _lifecycleManager.loadedPlugins.keys.toList()) {
      await _lifecycleManager.unregisterPlugin(pluginId);
    }
    _updateEventManagerState();
  }
}
