import 'package:flutter/material.dart';
import 'package:loom/features/plugin_system/domain/plugin_manager.dart';
import 'package:loom/features/plugin_system/presentation/explorer_plugin.dart';

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

    // Register Explorer Plugin
    final explorerPlugin = ExplorerPlugin();
    await _pluginManager.registerPlugin(explorerPlugin, context);

    // TODO(user): Register other built-in plugins here
    // await _pluginManager.registerPlugin(SettingsPlugin(), context);
    // await _pluginManager.registerPlugin(SearchPlugin(), context);
    // await _pluginManager.registerPlugin(ExportPlugin(), context);
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
