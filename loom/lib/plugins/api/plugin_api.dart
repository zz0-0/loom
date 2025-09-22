import 'dart:async';
import 'dart:isolate';
import 'package:loom/plugins/api/plugin_manifest.dart';

/// Base interface that all plugins must implement
abstract class Plugin {
  /// The plugin's manifest information
  PluginManifest get manifest;

  /// Initialize the plugin
  Future<void> initialize();

  /// Shutdown the plugin
  Future<void> shutdown();

  /// Handle a message from the main application
  Future<dynamic> handleMessage(String type, dynamic data);
}

/// Interface for plugins that provide commands
abstract class CommandPlugin implements Plugin {
  /// List of commands this plugin provides
  List<PluginCommand> get commands;

  /// Execute a command
  Future<CommandResult> executeCommand(
    String commandId,
    Map<String, dynamic> args,
  );
}

/// Interface for plugins that provide file operations
abstract class FilePlugin implements Plugin {
  /// List of supported file extensions
  List<String> get supportedExtensions;

  /// Handle file operations
  Future<FileOperationResult> handleFileOperation(
    String operation,
    String filePath,
    dynamic data,
  );
}

/// Interface for plugins that provide UI components
abstract class UIPlugin implements Plugin {
  /// Get UI components provided by this plugin
  Map<String, WidgetBuilder> get uiComponents;

  /// Handle UI events
  Future<void> handleUIEvent(String eventType, dynamic data);
}

/// Interface for plugins that hook into application lifecycle
abstract class LifecyclePlugin implements Plugin {
  /// Called when the application starts
  Future<void> onApplicationStart();

  /// Called when the application is about to close
  Future<void> onApplicationClose();

  /// Called when a workspace is opened
  Future<void> onWorkspaceOpen(String workspacePath);

  /// Called when a workspace is closed
  Future<void> onWorkspaceClose(String workspacePath);
}

/// Represents a plugin command
class PluginCommand {
  const PluginCommand({
    required this.id,
    required this.name,
    required this.description,
    required this.parameters,
    this.requiresConfirmation = false,
  });
  final String id;
  final String name;
  final String description;
  final Map<String, CommandParameter> parameters;
  final bool requiresConfirmation;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'parameters':
          parameters.map((key, value) => MapEntry(key, value.toJson())),
      'requiresConfirmation': requiresConfirmation,
    };
  }
}

/// Represents a command parameter
class CommandParameter {
  const CommandParameter({
    required this.name,
    required this.type,
    required this.description,
    required this.required,
    this.defaultValue,
  });
  final String name;
  final String type;
  final String description;
  final bool required;
  final dynamic defaultValue;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'required': required,
      'defaultValue': defaultValue,
    };
  }
}

/// Result of a command execution
class CommandResult {
  const CommandResult({
    required this.success,
    this.data,
    this.error,
    this.metadata,
  });

  factory CommandResult.success(
    dynamic data, {
    Map<String, dynamic>? metadata,
  }) {
    return CommandResult(
      success: true,
      data: data,
      metadata: metadata,
    );
  }

  factory CommandResult.error(String error, {Map<String, dynamic>? metadata}) {
    return CommandResult(
      success: false,
      error: error,
      metadata: metadata,
    );
  }
  final bool success;
  final dynamic data;
  final String? error;
  final Map<String, dynamic>? metadata;
}

/// Result of a file operation
class FileOperationResult {
  const FileOperationResult({
    required this.success,
    this.newPath,
    this.data,
    this.error,
  });

  factory FileOperationResult.success({String? newPath, dynamic data}) {
    return FileOperationResult(
      success: true,
      newPath: newPath,
      data: data,
    );
  }

  factory FileOperationResult.error(String error) {
    return FileOperationResult(
      success: false,
      error: error,
    );
  }
  final bool success;
  final String? newPath;
  final dynamic data;
  final String? error;
}

/// Function signature for building UI widgets
typedef WidgetBuilder = dynamic Function(Map<String, dynamic> props);

/// Message types for plugin communication
class PluginMessageTypes {
  // The analyzer prefers lowerCamelCase for constant names. These are
  // exported string values used as message identifiers; keep the names
  // stable but silence the lint to avoid renaming public API.

  // static const String COMMAND_EXECUTE = 'command.execute';

  // static const String FILE_OPERATION = 'file.operation';

  // static const String UI_EVENT = 'ui.event';

  // static const String LIFECYCLE_EVENT = 'lifecycle.event';

  // static const String PLUGIN_STATUS = 'plugin.status';

  // static const String ERROR = 'error';
}

/// Plugin lifecycle states
enum PluginState {
  unloaded,
  loading,
  loaded,
  initializing,
  active,
  error,
  unloading,
}

/// Plugin isolation mode
enum IsolationMode {
  none, // No isolation (not recommended)
  isolate, // Dart isolate
  process, // Separate process
}

/// Plugin load context
class PluginLoadContext {
  const PluginLoadContext({
    required this.pluginPath,
    required this.isolationMode,
    required this.configuration,
    this.mainSendPort,
  });
  final String pluginPath;
  final IsolationMode isolationMode;
  final Map<String, dynamic> configuration;
  final SendPort? mainSendPort;
}

/// Plugin runtime information
class PluginRuntimeInfo {
  const PluginRuntimeInfo({
    required this.pluginId,
    required this.state,
    required this.loadTime,
    required this.activeHooks,
    this.isolate,
    this.sendPort,
    this.receivePort,
  });
  final String pluginId;
  final PluginState state;
  final DateTime loadTime;
  final Isolate? isolate;
  final SendPort? sendPort;
  final ReceivePort? receivePort;
  final List<String> activeHooks;
}
