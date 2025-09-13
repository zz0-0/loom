import 'package:loom/features/core/plugin_system/index.dart';

// Use case for unregistering a plugin
class UnregisterPluginUseCase {

  UnregisterPluginUseCase(this._pluginManager);
  final PluginManager _pluginManager;

  Future<void> call(String pluginId) async {
    await _pluginManager.unregisterPlugin(pluginId);
  }
}
