import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/plugin_system/index.dart';

// Plugin list widget
class PluginListWidget extends ConsumerWidget {
  const PluginListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This would need to be implemented with proper providers
    return const Center(
      child: Text('Plugin System - Coming Soon'),
    );
  }
}

// Plugin item widget
class PluginItemWidget extends StatelessWidget {

  const PluginItemWidget({
    required this.plugin, super.key,
  });
  final Plugin plugin;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(plugin.name),
        subtitle: Text(plugin.description),
        trailing: const Switch(
          value: true, // Default to enabled for now
          onChanged: null, // Disable toggle for now
        ),
      ),
    );
  }
}

// Plugin settings widget
class PluginSettingsWidget extends ConsumerWidget {
  const PluginSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('Plugin Settings - Coming Soon'),
    );
  }
}
