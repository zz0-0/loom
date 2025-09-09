import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/domain/plugin_manager.dart';
import 'package:loom/features/plugins/git_plugin/domain/git_plugin.dart';

/// Plugin bootstrapper that initializes and registers all plugins
class PluginBootstrapper {
  factory PluginBootstrapper() => _instance;

  PluginBootstrapper._internal();
  static final PluginBootstrapper _instance = PluginBootstrapper._internal();

  final PluginManager _pluginManager = PluginManager();

  /// Initialize all plugins
  Future<void> initializePlugins(BuildContext context) async {
    await _pluginManager.initialize();

    // Check if context is still mounted after async operation
    if (!context.mounted) return;

    // Register built-in plugins
    await _registerBuiltInPlugins(context);
  }

  /// Register built-in plugins that are compiled with the app
  Future<void> _registerBuiltInPlugins(BuildContext context) async {
    // Check if context is still mounted
    if (!context.mounted) return;

    // Register Git Plugin
    final gitPlugin = GitPlugin();
    await _pluginManager.registerPlugin(gitPlugin, context);
  }

  /// Get the plugin manager instance
  PluginManager get pluginManager => _pluginManager;

  /// Handle file open event for all plugins
  void onFileOpen(String path) {
    _pluginManager.onFileOpen(path);
  }

  /// Handle workspace change event for all plugins
  void onWorkspaceChange(String workspacePath) {
    _pluginManager.onWorkspaceChange(workspacePath);
  }

  /// Dispose all plugins
  Future<void> dispose() async {
    await _pluginManager.dispose();
  }
}
