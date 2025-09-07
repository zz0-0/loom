import 'package:flutter/material.dart';
import 'package:loom/features/plugin_system/domain/plugin.dart';
import 'package:loom/features/plugin_system/presentation/command_api.dart';
import 'package:loom/features/plugin_system/presentation/settings_api.dart';
import 'package:loom/features/plugin_system/presentation/ui_api.dart';
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

    // Unregister components would be handled by the registry
  }

  void _registerUIComponents() {
    // Register sidebar item using the UI API
    final uiApi = PluginUIApi(_context!.registry);
    final sidebarItem = PluginUIComponents.createSidebarItem(
      pluginId: id,
      id: 'explorer',
      icon: Icons.folder,
      tooltip: 'Explorer',
      buildPanel: (context) =>
          const Placeholder(), // TODO(user): Implement actual explorer panel
    );
    uiApi.registerSidebarItem(id, sidebarItem);
  }

  void _registerCommands() {
    // Register commands using the command API
    CommandRegistry()
      ..registerCommand(
        id,
        Command(
          id: 'explorer.refresh',
          title: 'Refresh Explorer',
          description: 'Refresh the file explorer view',
          icon: Icons.refresh,
          category: CommandCategories.view,
          handler: _handleRefreshCommand,
        ),
      )
      ..registerCommand(
        id,
        Command(
          id: 'explorer.newFile',
          title: 'New File',
          description: 'Create a new file in the current directory',
          icon: Icons.add,
          shortcut: 'Ctrl+N',
          category: CommandCategories.file,
          handler: _handleNewFileCommand,
        ),
      )
      ..registerCommand(
        id,
        Command(
          id: 'explorer.newFolder',
          title: 'New Folder',
          description: 'Create a new folder in the current directory',
          icon: Icons.create_new_folder,
          shortcut: 'Ctrl+Shift+N',
          category: CommandCategories.file,
          handler: _handleNewFolderCommand,
        ),
      );
  }

  void _registerSettings() {
    // Register settings using the settings API
    final settingsRegistry = PluginSettingsRegistry();
    final settingsPage = PluginSettingsPage(
      title: 'Explorer',
      category: SettingsCategories.general,
      icon: Icons.folder,
      builder: _buildSettingsPage,
    );
    settingsRegistry.registerSettingsPage(id, settingsPage);
  }

  Future<void> _handleRefreshCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    // TODO(user): Implement refresh logic
    // This would refresh the file explorer view
  }

  Future<void> _handleNewFileCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    // TODO(user): Implement new file creation logic
    // This would show a dialog to create a new file
  }

  Future<void> _handleNewFolderCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    // TODO(user): Implement new folder creation logic
    // This would show a dialog to create a new folder
  }

  Widget _buildSettingsPage(BuildContext context, PluginSettingsApi settings) {
    return const Placeholder(); // TODO(user): Implement actual settings page
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
}

/// Concrete implementation of SidebarItem for the Explorer plugin
class ExplorerSidebarItem extends SidebarItem {
  ExplorerSidebarItem({
    required this.id,
    required this.icon,
    this.tooltip,
    this.onPressed,
  });
  @override
  final String id;
  @override
  final IconData icon;
  @override
  final String? tooltip;
  @override
  final VoidCallback? onPressed;

  @override
  Widget? buildPanel(BuildContext context) {
    return const Placeholder(); // TODO(user): Implement actual explorer panel
  }
}

/// Repository interfaces for Explorer plugin
abstract class FileSystemRepository {
  Future<List<String>> listDirectory(String path);
  Future<void> createFile(String path);
  Future<void> createDirectory(String path);
  Future<void> deleteFile(String path);
  Future<void> deleteDirectory(String path);
}

abstract class WorkspaceRepository {
  Future<String?> getCurrentWorkspace();
  Future<void> setCurrentWorkspace(String path);
  Stream<String?> watchCurrentWorkspace();
}
