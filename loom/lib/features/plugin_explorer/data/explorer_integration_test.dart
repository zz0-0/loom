import 'package:flutter/material.dart';
import 'package:loom/features/plugin_explorer/domain/explorer_domain.dart';
import 'package:loom/features/plugin_system/domain/plugin.dart';
import 'package:loom/features/plugin_system/presentation/command_api.dart';
import 'package:loom/features/plugin_system/presentation/settings_api.dart';
import 'package:loom/features/plugin_system/presentation/ui_api.dart';

/// Integration test for the Explorer plugin
class ExplorerPluginIntegrationTest {
  static Future<void> runTests() async {
    // Test 1: Plugin Registration
    await _testPluginRegistration();

    // Test 2: Command Registration
    await _testCommandRegistration();

    // Test 3: UI Component Registration
    await _testUIComponentRegistration();

    // Test 4: Settings Registration
    await _testSettingsRegistration();
  }

  static Future<void> _testPluginRegistration() async {
    final plugin = ExplorerPlugin();
    final context = PluginContext(
      registry: PluginRegistry(),
      settings: PluginSettings(plugin.id),
      eventBus: PluginEventBus(),
      permissions: PluginPermissions(),
      theme: ThemeData.light(),
    );

    await plugin.initialize(context);

    assert(plugin.id == 'loom.explorer', 'Plugin ID should be loom.explorer');
    assert(plugin.name == 'Explorer', 'Plugin name should be Explorer');
    assert(plugin.version == '1.0.0', 'Plugin version should be 1.0.0');
  }

  static Future<void> _testCommandRegistration() async {
    final commandRegistry = CommandRegistry();
    final plugin = ExplorerPlugin();

    // Simulate command registration
    commandRegistry.registerCommand(
      plugin.id,
      Command(
        id: 'explorer.refresh',
        title: 'Refresh Explorer',
        description: 'Refresh the file explorer view',
        icon: Icons.refresh,
        category: CommandCategories.view,
        handler: (context, args) async {
          // Mock handler
        },
      ),
    );

    assert(
      commandRegistry.isCommandAvailable('explorer.refresh'),
      'Command should be available after registration',
    );
    final command = commandRegistry.getCommand('explorer.refresh');
    assert(command != null, 'Command should not be null');
    assert(
      command!.title == 'Refresh Explorer',
      'Command title should be Refresh Explorer',
    );
  }

  static Future<void> _testUIComponentRegistration() async {
    final registry = PluginRegistry();
    final uiApi = PluginUIApi(registry);
    final sidebarItem = PluginUIComponents.createSidebarItem(
      pluginId: 'loom.explorer',
      id: 'explorer',
      icon: Icons.folder,
      tooltip: 'Explorer',
      buildPanel: (context) => const Placeholder(),
    );

    uiApi.registerSidebarItem('loom.explorer', sidebarItem);

    // Verify registration through the registry
    final components = registry.getPluginComponents('loom.explorer');
    assert(
      components.contains('explorer'),
      'Components should contain explorer',
    );
  }

  static Future<void> _testSettingsRegistration() async {
    final settingsRegistry = PluginSettingsRegistry();
    final plugin = ExplorerPlugin();

    final settingsPage = PluginSettingsPage(
      title: 'Explorer',
      category: SettingsCategories.general,
      icon: Icons.folder,
      builder: (context, settings) => const Placeholder(),
    );

    settingsRegistry.registerSettingsPage(plugin.id, settingsPage);

    final pageId = '${plugin.id}.explorer';
    final registeredPage = settingsRegistry.getSettingsPage(pageId);
    assert(registeredPage != null, 'Registered page should not be null');
    assert(
      registeredPage!.title == 'Explorer',
      'Registered page title should be Explorer',
    );
  }
}
