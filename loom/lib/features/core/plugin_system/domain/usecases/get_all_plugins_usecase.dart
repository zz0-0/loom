import 'package:loom/features/core/plugin_system/index.dart';

// Use case for getting all plugins
class GetAllPluginsUseCase {

  GetAllPluginsUseCase(this._pluginManager);
  final PluginManager _pluginManager;

  Map<String, Plugin> call() {
    return _pluginManager.loadedPlugins;
  }
}
