import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';

// Use cases for plugin management
class LoadPluginsUseCase {
  final PluginManager _pluginManager;

  LoadPluginsUseCase(this._pluginManager);

  Future<void> call() async {
    return await _pluginManager.initialize();
  }
}

class RegisterPluginUseCase {
  final PluginManager _pluginManager;

  RegisterPluginUseCase(this._pluginManager);

  Future<void> call(Plugin plugin, BuildContext context) async {
    await _pluginManager.registerPlugin(plugin, context);
  }
}

class UnregisterPluginUseCase {
  final PluginManager _pluginManager;

  UnregisterPluginUseCase(this._pluginManager);

  Future<void> call(String pluginId) async {
    await _pluginManager.unregisterPlugin(pluginId);
  }
}

class GetPluginUseCase {
  final PluginManager _pluginManager;

  GetPluginUseCase(this._pluginManager);

  Plugin? call(String pluginId) {
    return _pluginManager.getPlugin(pluginId);
  }
}

class GetAllPluginsUseCase {
  final PluginManager _pluginManager;

  GetAllPluginsUseCase(this._pluginManager);

  Map<String, Plugin> call() {
    return _pluginManager.loadedPlugins;
  }
}

class BootstrapPluginsUseCase {
  final PluginBootstrapper _pluginBootstrapper;

  BootstrapPluginsUseCase(this._pluginBootstrapper);

  Future<void> call(BuildContext context) async {
    await _pluginBootstrapper.initializePlugins(context);
  }
}
