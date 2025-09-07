import 'package:flutter/material.dart';
import 'package:loom/features/explorer/presentation/items/explorer_sidebar_item.dart';
import 'package:loom/features/plugin_system/domain/plugin.dart';
import 'package:loom/features/plugin_system/presentation/command_api.dart';
import 'package:loom/features/plugin_system/presentation/settings_api.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Explorer Plugin - Provides file system navigation and workspace management
class ExplorerPlugin implements Plugin {
  @override
  String get id => 'loom.explorer';

  @override
  String get name => 'Explorer';

  @override
  String get version => '1.0.0';

  @override
  String get description =>
      'File system navigation and workspace management for Loom';

  @override
  String get author => 'Loom Team';

  PluginContext? _context;

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;

    // Register UI components
    _registerUIComponents();

    // Register commands
    _registerCommands();

    // Register settings
    _registerSettings();
  }

  @override
  Future<void> dispose() async {
    // Save settings
    await _context?.settings.save();
  }

  void _registerUIComponents() {
    // Register sidebar item
    UIRegistry().registerSidebarItem(ExplorerSidebarItem());
  }

  void _registerCommands() {
    // Register explorer commands
    CommandRegistry()
      ..registerCommand(
        id,
        Command(
          id: 'explorer.refresh',
          title: 'Refresh Explorer',
          description: 'Refresh the file explorer view',
          handler: (context, args) async {
            // TODO(user): Implement refresh logic
          },
          category: CommandCategories.view,
        ),
      )
      ..registerCommand(
        id,
        Command(
          id: 'explorer.newFile',
          title: 'New File',
          description: 'Create a new file',
          handler: (context, args) async {
            // TODO(user): Implement new file creation
          },
          category: CommandCategories.file,
        ),
      )
      ..registerCommand(
        id,
        Command(
          id: 'explorer.newFolder',
          title: 'New Folder',
          description: 'Create a new folder',
          handler: (context, args) async {
            // TODO(user): Implement new folder creation
          },
          category: CommandCategories.file,
        ),
      );
  }

  void _registerSettings() {
    // Register explorer settings page
    PluginSettingsRegistry().registerSettingsPage(
      id,
      PluginSettingsPage(
        title: 'Explorer',
        category: SettingsCategories.general,
        builder: _buildSettingsPage,
      ),
    );
  }

  @override
  void onEditorLoad() {
    // Plugin-specific initialization when editor loads
  }

  @override
  void onActivate() {
    // Plugin activation logic
  }

  @override
  void onDeactivate() {
    // Plugin deactivation logic
  }

  @override
  void onFileOpen(String path) {
    // Handle file open events
    // Could update recent files, etc.
  }

  @override
  void onWorkspaceChange(String workspacePath) {
    // Handle workspace change events
    // Could refresh the explorer view
  }

  Widget _buildSettingsPage(BuildContext context, PluginSettingsApi settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explorer Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        // Add explorer-specific settings here
        SwitchListTile(
          title: const Text('Show Hidden Files'),
          value: settings.get<bool>('showHiddenFiles', false),
          onChanged: (bool? value) {
            if (value != null) {
              settings.set<bool>('showHiddenFiles', value);
            }
          },
        ),
        SwitchListTile(
          title: const Text('Auto Refresh'),
          value: settings.get<bool>('autoRefresh', true),
          onChanged: (bool? value) {
            if (value != null) {
              settings.set<bool>('autoRefresh', value);
            }
          },
        ),
      ],
    );
  }
}
