import 'dart:async';

import 'package:flutter/material.dart';

/// Typedef for plugin event listeners
typedef PluginEventListener = void Function(dynamic data);

/// Base interface for all plugins
abstract class Plugin {
  /// Unique identifier for the plugin
  String get id;

  /// Display name of the plugin
  String get name;

  /// Version of the plugin
  String get version;

  /// Description of what the plugin does
  String get description;

  /// Author of the plugin
  String get author;

  /// Initialize the plugin with the given context
  Future<void> initialize(PluginContext context);

  /// Dispose of the plugin and clean up resources
  Future<void> dispose();

  /// Called when the editor loads
  void onEditorLoad() {}

  /// Called when a file is opened
  void onFileOpen(String path) {}

  /// Called when the workspace changes
  void onWorkspaceChange(String workspacePath) {}

  /// Called when the plugin is activated (made visible/enabled)
  void onActivate() {}

  /// Called when the plugin is deactivated (hidden/disabled)
  void onDeactivate() {}
}

/// Context provided to plugins during initialization
class PluginContext {
  const PluginContext({
    required this.registry,
    required this.settings,
    required this.eventBus,
    required this.permissions,
    required this.theme,
  });

  /// Registry for registering UI components
  final PluginRegistry registry;

  /// Settings storage for the plugin
  final PluginSettings settings;

  /// Event bus for plugin communication
  final PluginEventBus eventBus;

  /// Permission manager
  final PluginPermissions permissions;

  /// Current theme data
  final ThemeData theme;
}

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

/// Settings storage for plugins
class PluginSettings {
  PluginSettings(this.pluginId);
  final String pluginId;
  final Map<String, dynamic> _settings = {};

  /// Get a setting value
  T get<T>(String key, T defaultValue) {
    final value = _settings[key];
    return value is T ? value : defaultValue;
  }

  /// Set a setting value
  void set<T>(String key, T value) {
    _settings[key] = value;
  }

  /// Save settings (persistence would be implemented here)
  Future<void> save() async {
    // TODO(user): Implement persistence using shared_preferences or similar
    // For now, this is a placeholder that would save to local storage
  }

  /// Load settings (persistence would be implemented here)
  Future<void> load() async {
    // TODO(user): Implement persistence using shared_preferences or similar
    // For now, this is a placeholder that would load from local storage
  }

  /// Get all settings as a map
  Map<String, dynamic> get allSettings => Map.unmodifiable(_settings);

  /// Clear all settings
  void clear() {
    _settings.clear();
  }

  /// Check if a setting exists
  bool hasSetting(String key) {
    return _settings.containsKey(key);
  }

  /// Remove a setting
  void removeSetting(String key) {
    _settings.remove(key);
  }
}

/// Event bus for plugin communication
class PluginEventBus {
  final Map<String, List<PluginEventListener>> _listeners = {};
  final Map<String, StreamController<dynamic>> _streamControllers = {};

  /// Subscribe to an event
  void subscribe(String event, PluginEventListener listener) {
    _listeners.putIfAbsent(event, () => []).add(listener);
  }

  /// Unsubscribe from an event
  void unsubscribe(String event, PluginEventListener listener) {
    _listeners[event]?.remove(listener);
  }

  /// Publish an event to all subscribers
  void publish(String event, [dynamic data]) {
    final listeners = _listeners[event];
    if (listeners != null) {
      for (final listener in listeners) {
        listener(data);
      }
    }

    // Also publish to stream if it exists
    final controller = _streamControllers[event];
    if (controller != null && !controller.isClosed) {
      controller.add(data);
    }
  }

  /// Get a stream for an event (for reactive programming)
  Stream<T> stream<T>(String event) {
    // Create a stream controller for this event if it doesn't exist
    if (!_streamControllers.containsKey(event)) {
      _streamControllers[event] = StreamController<T>.broadcast();
    }

    return _streamControllers[event]!.stream as Stream<T>;
  }

  /// Dispose of all stream controllers
  void dispose() {
    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
    _listeners.clear();
  }
}

/// Permission system for plugins
class PluginPermissions {
  final Set<String> _grantedPermissions = {};

  /// Check if a permission is granted
  bool hasPermission(String permission) {
    return _grantedPermissions.contains(permission);
  }

  /// Grant a permission
  void grantPermission(String permission) {
    _grantedPermissions.add(permission);
  }

  /// Revoke a permission
  void revokePermission(String permission) {
    _grantedPermissions.remove(permission);
  }

  /// Get all granted permissions
  Set<String> get grantedPermissions => Set.unmodifiable(_grantedPermissions);
}

/// Plugin lifecycle states
enum PluginState {
  uninitialized,
  initializing,
  active,
  deactivating,
  inactive,
  error,
}

/// Plugin metadata
class PluginMetadata {
  const PluginMetadata({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    this.dependencies = const [],
    this.permissions = const [],
  });

  final String id;
  final String name;
  final String version;
  final String description;
  final String author;
  final List<String> dependencies;
  final List<String> permissions;
}
