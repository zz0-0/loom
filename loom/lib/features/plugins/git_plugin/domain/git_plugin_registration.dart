import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';
import 'package:loom/features/plugins/git_plugin/index.dart';

/// Plugin registration for Git integration
class GitPluginRegistration {
  static Future<void> register(BuildContext context) async {
    final pluginManager = PluginManager();

    // Register the Git plugin
    await pluginManager.registerPlugin(GitPlugin(), context);
  }
}
