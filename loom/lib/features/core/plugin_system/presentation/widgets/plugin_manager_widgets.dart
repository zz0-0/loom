import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/plugin_system/index.dart';

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
