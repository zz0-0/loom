import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';
import 'package:loom/plugins/core/plugin_manager.dart';

/// Example usage of the Plugin System v2.0
/// This demonstrates how to initialize and use plugins
Future<void> main() async {
  print('=== Loom Plugin System v2.0 Demo ===');

  try {
    // Initialize the plugin system
    print('1. Initializing plugin system...');
    await PluginManager.instance.initialize(
      pluginsDirectory: 'lib/plugins/plugins',
    );
    print('✓ Plugin system initialized');

    // List installed plugins
    print('2. Installed plugins:');
    final installedPlugins = PluginManager.instance.getInstalledPlugins();
    for (final plugin in installedPlugins) {
      print('  - ${plugin.name} (${plugin.id}) v${plugin.version}');
      print('    ${plugin.description}');
    }

    // List active plugins
    print('3. Active plugins:');
    final activePlugins = PluginManager.instance.getActivePlugins();
    for (final plugin in activePlugins) {
      print('  - ${plugin.name} (${plugin.id})');
    }

    // Execute a command
    if (activePlugins.isNotEmpty) {
      final pluginId = activePlugins.first.id;
      print('4. Executing command on ${activePlugins.first.name}...');

      try {
        final result = await PluginManager.instance.executeCommand(
          pluginId,
          'hello.greet',
          {'name': 'Developer'},
        );

        if (result.success) {
          print('✓ Command result: ${result.data}');
        } else {
          print('✗ Command failed: ${result.error}');
        }
      } catch (e) {
        print('✗ Command execution failed: $e');
      }

      // Execute another command
      print('5. Executing custom greeting command...');
      try {
        final result = await PluginManager.instance.executeCommand(
          pluginId,
          'hello.custom',
          {'message': 'Welcome to the Plugin System v2.0!'},
        );

        if (result.success) {
          print('✓ Custom greeting: ${result.data}');
        } else {
          print('✗ Custom greeting failed: ${result.error}');
        }
      } catch (e) {
        print('✗ Custom greeting execution failed: $e');
      }

      // Test file operation
      print('6. Testing file operation...');
      try {
        final result = await PluginManager.instance.executeFileOperation(
          pluginId,
          'analyze',
          'example.txt',
          null,
        );

        if (result.success) {
          print('✓ File analysis result: ${result.data}');
        } else {
          print('✗ File operation failed: ${result.error}');
        }
      } catch (e) {
        print('✗ File operation execution failed: $e');
      }

      // Test lifecycle event
      print('7. Broadcasting lifecycle event...');
      try {
        await PluginManager.instance.handleLifecycleEvent('app.startup', null);
        print('✓ Lifecycle event broadcasted');
      } catch (e) {
        print('✗ Lifecycle event failed: $e');
      }
    }

    // Get plugins by capability
    print('8. Plugins with greeting capability:');
    final greetingPlugins =
        PluginManager.instance.getPluginsByCapability('hello.greet');
    for (final plugin in greetingPlugins) {
      print('  - ${plugin.name} (${plugin.id})');
    }

    // Get plugins for file extension
    print('9. Plugins supporting .txt files:');
    final txtPlugins = PluginManager.instance.getPluginsForFileExtension('txt');
    for (final plugin in txtPlugins) {
      print('  - ${plugin.name} (${plugin.id})');
    }

    // Show plugin statistics
    print('10. Plugin Statistics:');
    print('  - Installed: ${PluginManager.instance.installedPluginsCount}');
    print('  - Active: ${PluginManager.instance.activePluginsCount}');
  } catch (e) {
    print('✗ Demo failed: $e');
  } finally {
    // Shutdown the plugin system
    print('11. Shutting down plugin system...');
    await PluginManager.instance.shutdown();
    print('✓ Plugin system shutdown complete');
  }

  print('=== Demo Complete ===');
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
  Future<void> initialize() async {
    print('Custom plugin initialized');
  }

  @override
  Future<void> shutdown() async {
    print('Custom plugin shutdown');
  }

  @override
  Future<dynamic> handleMessage(String type, dynamic data) async {
    return {'message': 'Custom plugin response', 'type': type, 'data': data};
  }
}
