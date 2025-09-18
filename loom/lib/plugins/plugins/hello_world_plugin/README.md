# Hello World Plugin

This is an example plugin that demonstrates the capabilities of the Loom Plugin System v2.0.

## Features

- **Commands**: Provides greeting commands
- **File Operations**: Handles .txt and .md files
- **Lifecycle Hooks**: Responds to application events
- **UI Integration**: Can display notifications

## Commands

### `hello.greet`
Display a greeting message.

**Parameters:**
- `name` (optional): Name to greet (default: "World")

**Example:**
```json
{
  "commandId": "hello.greet",
  "args": {
    "name": "Alice"
  }
}
```

### `hello.custom`
Display a custom greeting message.

**Parameters:**
- `message` (required): Custom message to display

**Example:**
```json
{
  "commandId": "hello.custom",
  "args": {
    "message": "Welcome to Loom!"
  }
}
```

## File Operations

The plugin supports the following file operations for `.txt` and `.md` files:

### `read`
Simulates reading a file and returns sample content.

### `write`
Simulates writing content to a file.

### `analyze`
Provides basic file analysis including word count and sentiment.

## Lifecycle Events

The plugin responds to these application lifecycle events:

- `app.startup`: Logs plugin initialization
- `app.shutdown`: Logs plugin shutdown
- `workspace.open`: Logs workspace opening
- `workspace.close`: Logs workspace closing

## Usage

1. Copy this plugin directory to your Loom plugins folder
2. Restart Loom to load the plugin
3. Use the plugin commands through the plugin system API

## Development

To create your own plugin:

1. Create a `manifest.json` file with your plugin metadata
2. Implement the plugin interfaces you need (Plugin, CommandPlugin, etc.)
3. Export a factory function to create your plugin instance
4. Test your plugin with the Loom plugin system

## Plugin Manifest

```json
{
  "id": "hello-world-plugin",
  "name": "Hello World Plugin",
  "version": "1.0.0",
  "description": "A simple example plugin",
  "author": "Your Name",
  "entryPoint": "lib/your_plugin.dart",
  "permissions": ["ui.notification"],
  "capabilities": {
    "hooks": ["app.startup"],
    "commands": ["your.command"],
    "fileExtensions": [".txt"]
  }
}
```

## API Reference

- `PluginManager.instance.loadPlugin('hello-world-plugin')` - Load the plugin
- `PluginManager.instance.executeCommand('hello-world-plugin', 'hello.greet', {'name': 'User'})` - Execute commands
- `PluginManager.instance.handleFileOperation('hello-world-plugin', 'read', '/path/to/file.txt')` - Handle file operations