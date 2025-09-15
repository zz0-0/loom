import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/plugin_system/index.dart';

export 'plugin_state_management.dart';

final pluginSettingsRepositoryProvider =
    Provider<PluginSettingsRepository>((ref) {
  return LocalPluginSettingsRepository();
});

final pluginMetadataRepositoryProvider =
    Provider<PluginMetadataRepository>((ref) {
  return LocalPluginMetadataRepository();
});

final pluginPermissionsRepositoryProvider =
    Provider<PluginPermissionsRepository>((ref) {
  return LocalPluginPermissionsRepository();
});

// Providers for plugin management
final pluginManagerProviderOld = Provider<PluginManager>((ref) {
  return PluginManager();
});

final pluginBootstrapperProvider = Provider<PluginBootstrapper>((ref) {
  return PluginBootstrapper();
});

// Use case providers
final loadPluginsUseCaseProvider = Provider<LoadPluginsUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProviderOld);
  return LoadPluginsUseCase(pluginManager);
});

final registerPluginUseCaseProvider = Provider<RegisterPluginUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProviderOld);
  return RegisterPluginUseCase(pluginManager);
});

final unregisterPluginUseCaseProvider =
    Provider<UnregisterPluginUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProviderOld);
  return UnregisterPluginUseCase(pluginManager);
});

final getPluginUseCaseProvider = Provider<GetPluginUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProviderOld);
  return GetPluginUseCase(pluginManager);
});

final getAllPluginsUseCaseProvider = Provider<GetAllPluginsUseCase>((ref) {
  final pluginManager = ref.watch(pluginManagerProviderOld);
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
  PluginsNotifier(this._getAllPluginsUseCase) : super({}) {
    _loadPlugins();
  }
  final GetAllPluginsUseCase _getAllPluginsUseCase;

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
    state = Map<String, Plugin>.from(state)..remove(pluginId);
  }
}

// State management providers
final pluginManagerProvider =
    StateNotifierProvider<PluginManagerNotifier, PluginManagerState>((ref) {
  final settingsRepo = ref.watch(pluginSettingsRepositoryProvider);
  final metadataRepo = ref.watch(pluginMetadataRepositoryProvider);
  final permissionsRepo = ref.watch(pluginPermissionsRepositoryProvider);

  return PluginManagerNotifier(
    settingsRepository: settingsRepo,
    metadataRepository: metadataRepo,
    permissionsRepository: permissionsRepo,
  );
});
