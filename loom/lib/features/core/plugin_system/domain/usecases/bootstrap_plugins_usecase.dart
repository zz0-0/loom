import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';

// Use case for bootstrapping plugins
class BootstrapPluginsUseCase {

  BootstrapPluginsUseCase(this._pluginBootstrapper);
  final PluginBootstrapper _pluginBootstrapper;

  Future<void> call(BuildContext context) async {
    await _pluginBootstrapper.initializePlugins(context);
  }
}
