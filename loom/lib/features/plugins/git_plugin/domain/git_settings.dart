import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';

/// Handles settings for the Git plugin
class GitSettings {
  GitSettings(this.pluginId, this.context);

  final String pluginId;
  final PluginContext context;

  /// Register settings with the plugin system
  void registerSettings() {
    final settingsRegistry = PluginSettingsRegistry();
    final settingsPage = PluginSettingsPage(
      title: 'Git',
      category: SettingsCategories.general,
      icon: Icons.account_tree,
      builder: _buildSettingsPage,
    );
    settingsRegistry.registerSettingsPage(pluginId, settingsPage);
  }

  Widget _buildSettingsPage(BuildContext context, PluginSettingsApi settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Git Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        // Git executable path setting
        TextFormField(
          initialValue: settings.get('gitPath', '/usr/bin/git'),
          decoration: const InputDecoration(
            labelText: 'Git Executable Path',
            hintText: 'Path to git executable',
          ),
          onChanged: (value) => settings.set('gitPath', value),
        ),
        const SizedBox(height: 16),

        // Auto-fetch setting
        SwitchListTile(
          title: const Text('Auto-fetch'),
          subtitle: const Text('Automatically fetch changes from remote'),
          value: settings.get('autoFetch', false),
          onChanged: (value) => settings.set('autoFetch', value),
        ),

        // Default branch setting
        TextFormField(
          initialValue: settings.get('defaultBranch', 'main'),
          decoration: const InputDecoration(
            labelText: 'Default Branch',
            hintText: 'Default branch name for new repositories',
          ),
          onChanged: (value) => settings.set('defaultBranch', value),
        ),
      ],
    );
  }
}
