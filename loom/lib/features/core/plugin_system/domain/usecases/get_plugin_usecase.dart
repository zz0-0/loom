import 'package:loom/features/core/plugin_system/index.dart';

// Use case for getting a plugin by ID
class GetPluginUseCase {

  GetPluginUseCase(this._pluginManager);
  final PluginManager _pluginManager;

  Plugin? call(String pluginId) {
    return _pluginManager.getPlugin(pluginId);
  }
}
