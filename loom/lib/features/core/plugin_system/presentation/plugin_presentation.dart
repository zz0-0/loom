import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/plugin_system/data/plugin_repositories.dart';
import 'package:loom/features/core/plugin_system/domain/plugin.dart';

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

// State classes
class PluginManagerState {
  const PluginManagerState({
    this.plugins = const {},
    this.pluginStates = const {},
    this.isInitialized = false,
    this.error,
  });

  final Map<String, Plugin> plugins;
  final Map<String, PluginState> pluginStates;
  final bool isInitialized;
  final String? error;

  PluginManagerState copyWith({
    Map<String, Plugin>? plugins,
    Map<String, PluginState>? pluginStates,
    bool? isInitialized,
    String? error,
  }) {
    return PluginManagerState(
      plugins: plugins ?? this.plugins,
      pluginStates: pluginStates ?? this.pluginStates,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }
}

// State notifier for plugin management
class PluginManagerNotifier extends StateNotifier<PluginManagerState> {
  PluginManagerNotifier({
    required this.settingsRepository,
    required this.metadataRepository,
    required this.permissionsRepository,
  }) : super(const PluginManagerState());

  final PluginSettingsRepository settingsRepository;
  final PluginMetadataRepository metadataRepository;
  final PluginPermissionsRepository permissionsRepository;

  final PluginRegistry _registry = PluginRegistry();
  final Map<String, PluginContext> _pluginContexts = {};

  Future<void> initialize() async {
    try {
      state = state.copyWith(isInitialized: false);

      // Load installed plugins metadata
      await metadataRepository.getInstalledPlugins();

      // Initialize built-in plugins
      await _initializeBuiltInPlugins();

      state = state.copyWith(isInitialized: true);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _initializeBuiltInPlugins() async {
    // This would be where built-in plugins are registered
    // For now, it's empty but would load plugins from features/
  }

  Future<void> registerPlugin(Plugin plugin, BuildContext context) async {
    try {
      final pluginId = plugin.id;

      // Load plugin settings
      final settings = PluginSettings(pluginId);
      final savedSettings = await settingsRepository.loadSettings(pluginId);
      // Apply saved settings
      for (final entry in savedSettings.entries) {
        settings.set(entry.key, entry.value);
      }

      // Load plugin permissions
      final permissions = PluginPermissions();
      final grantedPermissions =
          await permissionsRepository.getGrantedPermissions(pluginId);
      for (final permission in grantedPermissions) {
        permissions.grantPermission(permission);
      }

      // Check if context is still mounted before using it
      if (!context.mounted) return;

      // Get theme after async operations
      final theme = Theme.of(context);

      // Create plugin context
      final pluginContext = PluginContext(
        registry: _registry,
        settings: settings,
        eventBus: PluginEventBus(),
        permissions: permissions,
        theme: theme,
      );

      // Store plugin context
      _pluginContexts[pluginId] = pluginContext;

      // Register plugin
      _registry.registerPlugin(plugin);

      // Initialize plugin
      state = state.copyWith(
        pluginStates: {
          ...state.pluginStates,
          pluginId: PluginState.initializing,
        },
      );

      await plugin.initialize(pluginContext);

      // Check if context is still mounted before updating state
      if (!context.mounted) return;

      // Update state
      state = state.copyWith(
        plugins: {
          ...state.plugins,
          pluginId: plugin,
        },
        pluginStates: {
          ...state.pluginStates,
          pluginId: PluginState.active,
        },
      );

      // Save plugin metadata
      final metadata = PluginMetadata(
        id: plugin.id,
        name: plugin.name,
        version: plugin.version,
        description: plugin.description,
        author: plugin.author,
      );
      await metadataRepository.savePluginMetadata(metadata);
    } catch (e) {
      state = state.copyWith(
        pluginStates: {
          ...state.pluginStates,
          plugin.id: PluginState.error,
        },
        error: e.toString(),
      );
    }
  }

  Future<void> unregisterPlugin(String pluginId) async {
    final plugin = state.plugins[pluginId];
    if (plugin == null) return;

    try {
      // Deactivate plugin
      state = state.copyWith(
        pluginStates: {
          ...state.pluginStates,
          pluginId: PluginState.deactivating,
        },
      );

      await plugin.dispose();

      // Save settings before removing
      final pluginContext = _pluginContexts[pluginId];
      if (pluginContext != null) {
        await settingsRepository.saveSettings(
          pluginId,
          pluginContext.settings.allSettings,
        );
        await permissionsRepository.saveGrantedPermissions(
          pluginId,
          pluginContext.permissions.grantedPermissions,
        );
      }

      // Remove plugin
      _registry.unregisterPlugin(pluginId);
      _pluginContexts.remove(pluginId);
      await metadataRepository.removePluginMetadata(pluginId);

      state = state.copyWith(
        plugins: Map.from(state.plugins)..remove(pluginId),
        pluginStates: Map.from(state.pluginStates)..remove(pluginId),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void onFileOpen(String path) {
    for (final plugin in state.plugins.values) {
      if (state.pluginStates[plugin.id] == PluginState.active) {
        plugin.onFileOpen(path);
      }
    }
  }

  void onWorkspaceChange(String workspacePath) {
    for (final plugin in state.plugins.values) {
      if (state.pluginStates[plugin.id] == PluginState.active) {
        plugin.onWorkspaceChange(workspacePath);
      }
    }
  }
}

// UI Components for plugin management
class PluginManagerWidget extends ConsumerWidget {
  const PluginManagerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pluginManagerProvider);

    if (!state.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text('Plugin system error: ${state.error}'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Installed Plugins',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: state.plugins.length,
            itemBuilder: (context, index) {
              final plugin = state.plugins.values.elementAt(index);
              final pluginState =
                  state.pluginStates[plugin.id] ?? PluginState.uninitialized;

              return PluginListItem(
                plugin: plugin,
                state: pluginState,
                onToggle: () {
                  if (pluginState == PluginState.active) {
                    ref.read(pluginManagerProvider.notifier).unregisterPlugin(
                          plugin.id,
                        );
                  } else {
                    // Re-register plugin
                    ref.read(pluginManagerProvider.notifier).registerPlugin(
                          plugin,
                          context,
                        );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class PluginListItem extends StatelessWidget {
  const PluginListItem({
    required this.plugin,
    required this.state,
    required this.onToggle,
    super.key,
  });

  final Plugin plugin;
  final PluginState state;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_getStateIcon(state)),
        title: Text(plugin.name),
        subtitle: Text('${plugin.description}\nVersion: ${plugin.version}'),
        trailing: Switch(
          value: state == PluginState.active,
          onChanged: (_) => onToggle(),
        ),
        isThreeLine: true,
      ),
    );
  }

  IconData _getStateIcon(PluginState state) {
    switch (state) {
      case PluginState.uninitialized:
      case PluginState.initializing:
      case PluginState.deactivating:
        return Icons.circle;
      case PluginState.active:
        return Icons.check_circle;
      case PluginState.inactive:
        return Icons.pause_circle;
      case PluginState.error:
        return Icons.error;
    }
  }
}
