import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';

/// Manages the lifecycle of plugins
class PluginLifecycleManager {
  factory PluginLifecycleManager() => _instance;

  PluginLifecycleManager._internal();
  static final PluginLifecycleManager _instance =
      PluginLifecycleManager._internal();

  final Map<String, Plugin> _loadedPlugins = {};
  final Map<String, PluginState> _pluginStates = {};
  final Map<String, PluginContext> _pluginContexts = {};
  final PluginRegistry _registry = PluginRegistry();

  /// Initialize the plugin system
  Future<void> initialize() async {
    // Load built-in plugins
    await _loadBuiltInPlugins();

    // Load external plugins from plugin directory
    await _loadExternalPlugins();
  }

  /// Load built-in plugins (compiled with the app)
  Future<void> _loadBuiltInPlugins() async {
    // For now, we'll register plugins manually
    // In the future, this could scan for plugins in the build
  }

  /// Load external plugins from the filesystem
  Future<void> _loadExternalPlugins() async {
    // TODO(user): Implement external plugin loading
    // This would scan a plugins directory and load .dart files
    // For now, this is a placeholder that could be implemented later
    // when the app supports dynamic plugin loading
  }

  /// Register a plugin
  Future<void> registerPlugin(Plugin plugin, BuildContext context) async {
    if (_loadedPlugins.containsKey(plugin.id)) {
      throw Exception('Plugin ${plugin.id} is already registered');
    }

    _loadedPlugins[plugin.id] = plugin;
    _pluginStates[plugin.id] = PluginState.uninitialized;
    _registry.registerPlugin(plugin);

    // Create plugin context
    final pluginContext = PluginContext(
      registry: _registry,
      settings: PluginSettings(plugin.id),
      eventBus: PluginEventBus(),
      permissions: PluginPermissions(),
      theme: Theme.of(context),
    );

    _pluginContexts[plugin.id] = pluginContext;

    // Initialize the plugin
    await _initializePlugin(plugin.id);
  }

  /// Initialize a specific plugin
  Future<void> _initializePlugin(String pluginId) async {
    final plugin = _loadedPlugins[pluginId];
    final context = _pluginContexts[pluginId];

    if (plugin == null || context == null) {
      throw Exception('Plugin $pluginId not found');
    }

    try {
      _pluginStates[pluginId] = PluginState.initializing;
      await plugin.initialize(context);
      _pluginStates[pluginId] = PluginState.active;

      // Call lifecycle hooks
      plugin
        ..onEditorLoad()
        ..onActivate();
    } catch (e) {
      _pluginStates[pluginId] = PluginState.error;
      throw Exception('Failed to initialize plugin $pluginId: $e');
    }
  }

  /// Unregister a plugin
  Future<void> unregisterPlugin(String pluginId) async {
    final plugin = _loadedPlugins[pluginId];
    if (plugin == null) return;

    try {
      // Dispose the plugin
      await plugin.dispose();

      // Clean up
      _loadedPlugins.remove(pluginId);
      _pluginStates.remove(pluginId);
      _pluginContexts.remove(pluginId);
      _registry.unregisterPlugin(pluginId);
    } catch (e) {
      throw Exception('Failed to unregister plugin $pluginId: $e');
    }
  }

  /// Activate a plugin
  Future<void> activatePlugin(String pluginId) async {
    final plugin = _loadedPlugins[pluginId];
    if (plugin == null) return;

    if (_pluginStates[pluginId] == PluginState.active) return;

    try {
      await _initializePlugin(pluginId);
    } catch (e) {
      throw Exception('Failed to activate plugin $pluginId: $e');
    }
  }

  /// Get a plugin by ID
  Plugin? getPlugin(String pluginId) {
    return _loadedPlugins[pluginId];
  }

  /// Get the state of a plugin
  PluginState getPluginState(String pluginId) {
    return _pluginStates[pluginId] ?? PluginState.uninitialized;
  }

  /// Get the context of a plugin
  PluginContext? getPluginContext(String pluginId) {
    return _pluginContexts[pluginId];
  }

  /// Get all loaded plugins
  Map<String, Plugin> get loadedPlugins => Map.unmodifiable(_loadedPlugins);

  /// Get all plugin states
  Map<String, PluginState> get pluginStates => Map.unmodifiable(_pluginStates);

  /// Get the plugin registry
  PluginRegistry get registry => _registry;
}
