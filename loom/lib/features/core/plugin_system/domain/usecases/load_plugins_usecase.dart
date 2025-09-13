import 'package:loom/features/core/plugin_system/index.dart';

// Use case for loading plugins
class LoadPluginsUseCase {

  LoadPluginsUseCase(this._pluginManager);
  final PluginManager _pluginManager;

  Future<void> call() async {
    return _pluginManager.initialize();
  }
}
