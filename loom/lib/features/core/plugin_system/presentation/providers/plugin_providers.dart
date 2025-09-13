import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/plugin_system/index.dart';

// Providers for plugin management
final pluginManagerProvider = Provider<PluginManager>((ref) {
  return PluginManager();
});

final pluginBootstrapperProvider = Provider<PluginBootstrapper>((ref) {
  return PluginBootstrapper();
});

// Use case providers
final loadPluginsUseCaseProvider = Provider<LoadPluginsUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProvider);
  return LoadPluginsUseCase(pluginManager);
});

final registerPluginUseCaseProvider = Provider<RegisterPluginUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProvider);
  return RegisterPluginUseCase(pluginManager);
});

final unregisterPluginUseCaseProvider =
    Provider<UnregisterPluginUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProvider);
  return UnregisterPluginUseCase(pluginManager);
});

final getPluginUseCaseProvider = Provider<GetPluginUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProvider);
  return GetPluginUseCase(pluginManager);
});

final getAllPluginsUseCaseProvider = Provider<GetAllPluginsUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProvider);
  return GetAllPluginsUseCase(pluginManager);
});

final bootstrapPluginsUseCaseProvider =
    Provider<BootstrapPluginsUseCase>((ref) {
  final pluginBootstrapper = ref.watch(pluginBootstrapperProvider);
  return BootstrapPluginsUseCase(pluginBootstrapper);
});

// State providers
final pluginsProvider =
    StateNotifierProvider<PluginsNotifier, Map<String, Plugin>>((ref) {
  final getAllPluginsUseCase = ref.watch(getAllPluginsUseCaseProvider);
  return PluginsNotifier(getAllPluginsUseCase);
});

class PluginsNotifier extends StateNotifier<Map<String, Plugin>> {
  final GetAllPluginsUseCase _getAllPluginsUseCase;

  PluginsNotifier(this._getAllPluginsUseCase) : super({}) {
    _loadPlugins();
  }

  void _loadPlugins() {
    state = _getAllPluginsUseCase();
  }

  Future<void> registerPlugin(Plugin plugin, BuildContext context) async {
    // This would need to be injected properly through ref
    // For now, just update state
    state = {...state, plugin.id: plugin};
  }

  Future<void> unregisterPlugin(String pluginId) async {
    // This would need to be injected properly through ref
    // For now, just update state
    final newState = Map<String, Plugin>.from(state);
    newState.remove(pluginId);
    state = newState;
  }
}
