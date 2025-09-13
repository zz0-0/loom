import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';

// Use case for registering a plugin
class RegisterPluginUseCase {

  RegisterPluginUseCase(this._pluginManager);
  final PluginManager _pluginManager;

  Future<void> call(Plugin plugin, BuildContext context) async {
    await _pluginManager.registerPlugin(plugin, context);
  }
}
