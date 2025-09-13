import 'dart:async';
import 'package:loom/features/core/plugin_system/domain/entities/plugin_context.dart';

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
