import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/domain/plugin_manager.dart';
import 'package:loom/features/plugins/git_plugin/domain/git_plugin.dart';

/// Plugin registration for Git integration
class GitPluginRegistration {
  static Future<void> register(BuildContext context) async {
    final pluginManager = PluginManager();

    // Register the Git plugin
    await pluginManager.registerPlugin(GitPlugin(), context);
  }
}
