import 'dart:isolate';
import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';

/// Example plugin that demonstrates the plugin system v2.0
class HelloWorldPlugin
    implements Plugin, CommandPlugin, FilePlugin, LifecyclePlugin {
  late PluginManifest _manifest;
  late SendPort _mainSendPort;
  late ReceivePort _receivePort;
  bool _initialized = false;

  @override
  PluginManifest get manifest => _manifest;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    _log('Initializing Hello World Plugin');

    // Set up communication
    _receivePort = ReceivePort();
    _receivePort.listen(_handleMessage);

    // Send port back to main isolate
    _mainSendPort.send(_receivePort.sendPort);

    _initialized = true;
    _log('Hello World Plugin initialized successfully');
  }

  @override
  Future<void> shutdown() async {
    if (!_initialized) return;

    _log('Shutting down Hello World Plugin');
    _receivePort.close();
    _initialized = false;
  }

  @override
  Future<dynamic> handleMessage(String type, dynamic data) async {
    _log('Received message: $type with data: $data');

    switch (type) {
      case 'command.execute':
        return _handleCommand(data);
      case 'file.operation':
        return _handleFileOperation(data);
      case 'lifecycle.event':
        return _handleLifecycleEvent(data);
      case 'ui.event':
        return _handleUIEvent(data);
      default:
        return {'status': 'unknown_message_type', 'type': type};
    }
  }

  // CommandPlugin implementation
  @override
  List<PluginCommand> get commands => [
        const PluginCommand(
          id: 'hello.greet',
          name: 'Greet User',
          description: 'Display a greeting message',
          parameters: {
            'name': CommandParameter(
              name: 'name',
              type: 'string',
              description: 'Name to greet',
              required: false,
              defaultValue: 'World',
            ),
          },
        ),
        const PluginCommand(
          id: 'hello.custom',
          name: 'Custom Greeting',
          description: 'Display a custom greeting message',
          parameters: {
            'message': CommandParameter(
              name: 'message',
              type: 'string',
              description: 'Custom message to display',
              required: true,
            ),
          },
        ),
      ];

  @override
  Future<CommandResult> executeCommand(
    String commandId,
    Map<String, dynamic> args,
  ) async {
    switch (commandId) {
      case 'hello.greet':
        final name = args['name'] ?? 'World';
        final message = 'Hello, $name!';
        _log('Greeting: $message');
        return CommandResult.success({'message': message});

      case 'hello.custom':
        final message = args['message'] as String?;
        if (message == null || message.isEmpty) {
          return CommandResult.error('Message parameter is required');
        }
        _log('Custom greeting: $message');
        return CommandResult.success({'message': message});

      default:
        return CommandResult.error('Unknown command: $commandId');
    }
  }

  // FilePlugin implementation
  @override
  List<String> get supportedExtensions => ['.txt', '.md'];

  @override
  Future<FileOperationResult> handleFileOperation(
    String operation,
    String filePath,
    dynamic data,
  ) async {
    _log('File operation: $operation on $filePath');

    switch (operation) {
      case 'read':
        // Simulate reading a file
        final content = 'Hello from Hello World Plugin!\nFile: $filePath';
        return FileOperationResult.success(data: content);

      case 'write':
        // Simulate writing to a file
        final content = data as String? ?? 'Default content';
        _log('Would write to $filePath: $content');
        return FileOperationResult.success();

      case 'analyze':
        // Simulate analyzing a file
        final analysis = {
          'file': filePath,
          'wordCount': 42,
          'hasGreeting': true,
          'sentiment': 'positive',
        };
        return FileOperationResult.success(data: analysis);

      default:
        return FileOperationResult.error('Unsupported operation: $operation');
    }
  }

  // LifecyclePlugin implementation
  @override
  Future<void> onApplicationStart() async {
    _log('Application started - Hello World Plugin is ready!');
    // Could perform initialization tasks here
  }

  @override
  Future<void> onApplicationClose() async {
    _log('Application closing - Goodbye from Hello World Plugin!');
    // Could perform cleanup tasks here
  }

  @override
  Future<void> onWorkspaceOpen(String workspacePath) async {
    _log('Workspace opened: $workspacePath');
    // Could initialize workspace-specific features here
  }

  @override
  Future<void> onWorkspaceClose(String workspacePath) async {
    _log('Workspace closed: $workspacePath');
    // Could clean up workspace-specific resources here
  }

  // Private helper methods
  Future<dynamic> _handleCommand(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final commandId = data['commandId'] as String?;
      final args = data['args'] as Map<String, dynamic>? ?? {};

      if (commandId != null) {
        final result = await executeCommand(commandId, args);
        return {
          'success': result.success,
          'data': result.data,
          'error': result.error,
        };
      }
    }
    return {'error': 'Invalid command data'};
  }

  Future<dynamic> _handleFileOperation(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final operation = data['operation'] as String?;
      final filePath = data['filePath'] as String?;
      final fileData = data['data'];

      if (operation != null && filePath != null) {
        final result = await handleFileOperation(operation, filePath, fileData);
        return {
          'success': result.success,
          'newPath': result.newPath,
          'data': result.data,
          'error': result.error,
        };
      }
    }
    return {'error': 'Invalid file operation data'};
  }

  Future<dynamic> _handleLifecycleEvent(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final eventType = data['eventType'] as String?;
      final eventData = data['data'];

      switch (eventType) {
        case 'app.startup':
          await onApplicationStart();
        case 'app.shutdown':
          await onApplicationClose();
        case 'workspace.open':
          final workspacePath = eventData as String?;
          if (workspacePath != null) {
            await onWorkspaceOpen(workspacePath);
          }
        case 'workspace.close':
          final closePath = eventData as String?;
          if (closePath != null) {
            await onWorkspaceClose(closePath);
          }
      }
    }
    return {'status': 'lifecycle_event_handled'};
  }

  Future<dynamic> _handleUIEvent(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final eventType = data['eventType'] as String?;
      _log('UI Event: $eventType with data: $data');
    }
    return {'status': 'ui_event_handled'};
  }

  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      final type = message['type'] as String?;
      final data = message['data'];
      final responsePort = message['responsePort'] as SendPort?;

      if (type != null && responsePort != null) {
        handleMessage(type, data)
            .then(responsePort.send)
            .catchError((Object error) {
          responsePort.send({'error': error.toString()});
        });
      }
    }
  }

  void _log(String message) {
    // Send log message to main isolate
    _mainSendPort.send({
      'type': 'log',
      'data': '[HelloWorldPlugin] $message',
    });
  }
}

/// Factory function to create the plugin instance
/// This is called by the plugin system when loading the plugin
Plugin createHelloWorldPlugin(PluginManifest manifest, SendPort mainSendPort) {
  final plugin = HelloWorldPlugin()
    .._manifest = manifest
    .._mainSendPort = mainSendPort;
  return plugin;
}
