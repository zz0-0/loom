# 🔌 Loom Plugin System

## Overview

Loom features a comprehensive plugin architecture that allows developers to extend the editor's functionality through a clean, type-safe API. The plugin system follows Clean Architecture principles and provides APIs for commands, UI components, and settings.

## Architecture

### Core Components

```
lib/plugins/
├── core/
│   ├── plugin.dart          # Core plugin interfaces
│   └── plugin_manager.dart  # Plugin lifecycle management
├── api/
│   ├── command_api.dart     # Command registration API
│   ├── ui_api.dart          # UI component registration API
│   └── settings_api.dart    # Settings management API
├── examples/
│   └── explorer_plugin.dart # Example plugin implementation
└── plugin_bootstrapper.dart # Plugin initialization
```

### Plugin Lifecycle

1. **Registration**: Plugins are registered with the PluginManager
2. **Initialization**: PluginContext is provided with dependencies
3. **Activation**: Plugin components are registered with respective APIs
4. **Operation**: Plugin responds to events and user interactions
5. **Deactivation**: Plugin cleans up resources
6. **Unregistration**: Plugin is removed from the system

## Plugin APIs

### Command API

Register custom commands with keyboard shortcuts:

```dart
class MyPlugin implements Plugin {
  Future<void> _registerCommands() async {
    final commandRegistry = CommandRegistry();

    commandRegistry.registerCommand(id, Command(
      id: 'myplugin.hello',
      title: 'Say Hello',
      description: 'Display a greeting message',
      icon: Icons.waving_hand,
      shortcut: 'Ctrl+Shift+H',
      category: CommandCategories.tools,
      handler: _handleHelloCommand,
    ));
  }

  Future<void> _handleHelloCommand(BuildContext context, Map<String, dynamic> args) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hello from plugin!')),
    );
  }
}
```

### UI API

Add sidebar items, content providers, and menu items:

```dart
Future<void> _registerUIComponents() async {
  final uiApi = PluginUIApi(id);

  // Register sidebar item
  final sidebarItem = ExplorerSidebarItem(
    id: 'mytool',
    icon: Icons.build,
    tooltip: 'My Tool',
  );
  uiApi.registerSidebarItem(sidebarItem);

  // Register content provider
  final contentProvider = PluginContentProvider(
    pluginId: id,
    id: 'mycontent',
    build: (context) => const MyContentWidget(),
    canHandle: (contentId) => contentId == 'mycontent',
  );
  uiApi.registerContentProvider(contentProvider);
}
```

### Settings API

Create custom settings pages:

```dart
Future<void> _registerSettings() async {
  final settingsRegistry = PluginSettingsRegistry();

  final settingsPage = PluginSettingsPage(
    title: 'My Plugin',
    category: SettingsCategories.general,
    icon: Icons.settings,
    builder: (context, settings) => _buildSettingsPage(context, settings),
  );

  settingsRegistry.registerSettingsPage(id, settingsPage);
}

Widget _buildSettingsPage(BuildContext context, PluginSettingsApi settings) {
  return Column(
    children: [
      SwitchListTile(
        title: const Text('Enable Feature'),
        value: settings.get('featureEnabled', false),
        onChanged: (value) => settings.set('featureEnabled', value),
      ),
    ],
  );
}
```

## Example Plugin: Explorer

The Explorer plugin demonstrates the complete plugin architecture:

```dart
class ExplorerPlugin implements Plugin {
  @override
  String get id => 'loom.explorer';

  @override
  String get name => 'Explorer';

  @override
  Future<void> initialize(PluginContext context) async {
    // Register all components
    _registerUIComponents();
    _registerCommands();
    _registerSettings();
  }

  // Implementation details...
}
```

## Plugin Development

### Creating a New Plugin

1. **Create Plugin Class**:
   ```dart
   class MyPlugin implements Plugin {
     @override
     String get id => 'mycompany.myplugin';
     @override
     String get name => 'My Plugin';
     // ... implement other required methods
   }
   ```

2. **Register Components**:
   - Use Command API for actions
   - Use UI API for interface elements
   - Use Settings API for configuration

3. **Handle Events**:
   - Override lifecycle methods (`onActivate`, `onDeactivate`)
   - Respond to editor events (`onFileOpen`, `onWorkspaceChange`)

### Best Practices

- **Clean Architecture**: Keep domain logic separate from UI
- **Error Handling**: Implement proper error handling and logging
- **Resource Management**: Clean up resources in `dispose()`
- **Type Safety**: Use strong typing throughout
- **Documentation**: Document public APIs and usage

## Integration with Main App

Plugins are initialized through the PluginBootstrapper:

```dart
class PluginBootstrapper {
  static Future<void> initializePlugins(BuildContext context) async {
    final pluginManager = PluginManager();

    // Register built-in plugins
    await pluginManager.registerPlugin(ExplorerPlugin(), context);

    // Register external plugins...
  }
}
```

## Future Enhancements

- **Plugin Marketplace**: Online repository for plugin discovery
- **Plugin Dependencies**: Support for plugin dependencies
- **Hot Reloading**: Runtime plugin updates without restart
- **Plugin Permissions**: Granular permission system
- **Plugin Analytics**: Usage tracking and metrics

## Contributing

To contribute a plugin:

1. Follow the plugin interface contract
2. Implement proper error handling
3. Add comprehensive documentation
4. Include unit tests
5. Submit a pull request

## License

Plugin system and APIs are licensed under MIT. Individual plugins may have their own licenses.
