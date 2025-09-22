import 'dart:developer';

import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';
import 'package:loom/plugins/core/plugin_manager.dart';

/// Example usage of the Plugin System v2.0
/// This demonstrates how to initialize and use plugins
Future<void> main() async {
  final pm = PluginManager.instance;
  try {
    // Initialize the plugin system
    await pm.initialize(
      pluginsDirectory: 'lib/plugins/plugins',
    );

    // List installed plugins
    // final installedPlugins = PluginManager.instance.getInstalledPlugins();
    // for (final plugin in installedPlugins) {}

    // List active plugins
    final activePlugins = pm.getActivePlugins();
    // for (final plugin in activePlugins) {}

    // Execute a command
    if (activePlugins.isNotEmpty) {
      final pluginId = activePlugins.first.id;

      try {
        final result = await pm.executeCommand(
          pluginId,
          'hello.greet',
          {
            'name': 'Developer',
          },
        );

        if (result.success) {
        } else {}
      } catch (e) {
        // Log unexpected errors during demo runs so analyzer doesn't flag empty catches
        log(
          'plugin_demo: executeCommand hello.greet failed: $e',
          name: 'plugin_demo',
        );
      }

      // Execute another command
      try {
        final result = await pm.executeCommand(
          pluginId,
          'hello.custom',
          {
            'message': 'Welcome to the Plugin System v2.0!',
          },
        );

        if (result.success) {
        } else {}
      } catch (e) {
        log(
          'plugin_demo: executeCommand hello.custom failed: $e',
          name: 'plugin_demo',
        );
      }

      // Test file operation
      try {
        final result = await pm.executeFileOperation(
          pluginId,
          'analyze',
          'example.txt',
          null,
        );

        if (result.success) {
        } else {}
      } catch (e) {
        log(
          'plugin_demo: executeFileOperation analyze failed: $e',
          name: 'plugin_demo',
        );
      }

      // Test lifecycle event
      try {
        await pm.handleLifecycleEvent(
          'app.startup',
          null,
        );
      } catch (e) {
        log(
          'plugin_demo: handleLifecycleEvent failed: $e',
          name: 'plugin_demo',
        );
      }
    }

    // Get plugins by capability
    pm
        .getPluginsByCapability('hello.greet')
        // Touch the list to avoid unused variable lints in the demo
        .length;

    // Get plugins for file extension
    pm
        .getPluginsForFileExtension('txt')
        // Touch the list to avoid unused variable lints in the demo
        .length;

    // Show plugin statistics
  } catch (e) {
    log('plugin_demo: main failed: $e', name: 'plugin_demo');
  } finally {
    // Shutdown the plugin system
    await pm.shutdown();
  }
}

/// Example of how to create a custom plugin
class CustomExamplePlugin implements Plugin {
  @override
  PluginManifest get manifest => const PluginManifest(
        id: 'custom-example',
        name: 'Custom Example Plugin',
        version: '1.0.0',
        description: 'A custom plugin example',
        author: 'Developer',
        entryPoint: 'lib/custom_plugin.dart',
        permissions: <String>[],
        metadata: <String, dynamic>{},
        dependencies: PluginDependencies(
          plugins: <String>[],
          packages: <String, String>{},
        ),
        capabilities: PluginCapabilities(
          hooks: <String>[],
          commands: <String>['custom.example'],
          fileExtensions: <String>[],
          customCapabilities: <String, dynamic>{},
        ),
      );

  @override
  Future<void> initialize() async {}

  @override
  Future<void> shutdown() async {}

  @override
  Future<dynamic> handleMessage(String type, dynamic data) async {
    return {'message': 'Custom plugin response', 'type': type, 'data': data};
  }
}
