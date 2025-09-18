import 'dart:async';
import 'dart:isolate';
import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';

/// Manages plugin isolation using Dart isolates
class PluginIsolateManager {
  final Map<String, PluginRuntimeInfo> _activePlugins = {};
  final Map<String, Isolate> _isolates = {};
  final Map<String, SendPort> _sendPorts = {};
  final Map<String, ReceivePort> _receivePorts = {};

  /// Load a plugin in an isolate
  Future<PluginRuntimeInfo> loadPlugin(
    PluginManifest manifest,
    PluginLoadContext context,
  ) async {
    if (_activePlugins.containsKey(manifest.id)) {
      throw PluginIsolationException('Plugin ${manifest.id} is already loaded');
    }

    final receivePort = ReceivePort();
    final completer = Completer<PluginRuntimeInfo>();

    // Listen for messages from the plugin isolate
    receivePort.listen((message) {
      if (message is SendPort) {
        // Plugin isolate is ready, store the send port
        _sendPorts[manifest.id] = message;

        final runtimeInfo = PluginRuntimeInfo(
          pluginId: manifest.id,
          state: PluginState.active,
          loadTime: DateTime.now(),
          isolate: _isolates[manifest.id],
          sendPort: message,
          receivePort: receivePort,
          activeHooks: manifest.capabilities.hooks,
        );

        _activePlugins[manifest.id] = runtimeInfo;
        completer.complete(runtimeInfo);
      } else if (message is Map<String, dynamic>) {
        // Handle plugin messages
        _handlePluginMessage(manifest.id, message);
      }
    });

    try {
      // Spawn the plugin isolate
      final isolate = await Isolate.spawn(
        _pluginIsolateEntry,
        {
          'manifest': manifest.toJson(),
          'context': {
            'pluginPath': context.pluginPath,
            'isolationMode': context.isolationMode.toString(),
            'configuration': context.configuration,
          },
          'mainSendPort': receivePort.sendPort,
        },
        debugName: 'Plugin-${manifest.id}',
      );

      _isolates[manifest.id] = isolate;
      _receivePorts[manifest.id] = receivePort;

      return await completer.future;
    } catch (e) {
      receivePort.close();
      throw PluginIsolationException(
        'Failed to load plugin ${manifest.id}: $e',
      );
    }
  }

  /// Unload a plugin and terminate its isolate
  Future<void> unloadPlugin(String pluginId) async {
    final runtimeInfo = _activePlugins[pluginId];
    if (runtimeInfo == null) {
      throw PluginIsolationException('Plugin $pluginId is not loaded');
    }

    // Send shutdown message to plugin
    final sendPort = _sendPorts[pluginId];
    if (sendPort != null) {
      sendPort.send({
        'type': 'shutdown',
        'data': null,
      });
    }

    // Wait a bit for graceful shutdown
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Terminate isolate
    final isolate = _isolates[pluginId];
    if (isolate != null) {
      isolate.kill(priority: Isolate.immediate);
      _isolates.remove(pluginId);
    }

    // Clean up ports
    final receivePort = _receivePorts[pluginId];
    if (receivePort != null) {
      receivePort.close();
      _receivePorts.remove(pluginId);
    }

    _sendPorts.remove(pluginId);
    _activePlugins.remove(pluginId);
  }

  /// Send a message to a plugin
  Future<dynamic> sendMessage(
    String pluginId,
    String type,
    dynamic data,
  ) async {
    final sendPort = _sendPorts[pluginId];
    if (sendPort == null) {
      throw PluginIsolationException(
        'Plugin $pluginId is not loaded or not ready',
      );
    }

    final completer = Completer<dynamic>();
    final responsePort = ReceivePort();

    responsePort.listen((message) {
      responsePort.close();
      if (message is Map<String, dynamic> && message['type'] == 'response') {
        completer.complete(message['data']);
      } else if (message is Map<String, dynamic> &&
          message['type'] == 'error') {
        completer.completeError(
          Exception(message['error'] as String? ?? 'Unknown error'),
        );
      } else {
        completer.complete(message);
      }
    });

    sendPort.send({
      'type': type,
      'data': data,
      'responsePort': responsePort.sendPort,
    });

    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        responsePort.close();
        throw PluginIsolationException('Plugin $pluginId timed out');
      },
    );
  }

  /// Get runtime info for a plugin
  PluginRuntimeInfo? getPluginInfo(String pluginId) {
    return _activePlugins[pluginId];
  }

  /// Get all active plugins
  Map<String, PluginRuntimeInfo> getActivePlugins() {
    return Map.unmodifiable(_activePlugins);
  }

  /// Handle messages from plugin isolates
  void _handlePluginMessage(String pluginId, Map<String, dynamic> message) {
    final type = message['type'] as String?;
    final data = message['data'];

    switch (type) {
      case 'log':
        _handleLogMessage(pluginId, data);
      case 'error':
        _handleErrorMessage(pluginId, data);
      case 'status':
        _handleStatusMessage(pluginId, data);
      default:
        // Unknown message type, ignore or log
        break;
    }
  }

  void _handleLogMessage(String pluginId, dynamic data) {
    // TODO: Integrate with main app logging system
    print('[Plugin $pluginId] $data');
  }

  void _handleErrorMessage(String pluginId, dynamic data) {
    // TODO: Integrate with main app error handling
    print('[Plugin $pluginId ERROR] $data');
  }

  void _handleStatusMessage(String pluginId, dynamic data) {
    // TODO: Update plugin status in registry
    print('[Plugin $pluginId STATUS] $data');
  }
}

/// Entry point for plugin isolates
void _pluginIsolateEntry(Map<String, dynamic> message) {
  final manifestJson = message['manifest'] as Map<String, dynamic>;
  final contextJson = message['context'] as Map<String, dynamic>;
  final mainSendPort = message['mainSendPort'] as SendPort;

  final manifest = PluginManifest.fromJson(manifestJson);
  final context = PluginLoadContext(
    pluginPath: contextJson['pluginPath'] as String,
    isolationMode: IsolationMode.isolate,
    configuration: contextJson['configuration'] as Map<String, dynamic>,
  );

  // Create plugin instance and send port back to main isolate
  final plugin = _createPluginInstance(manifest, context);
  final pluginPort = ReceivePort();

  pluginPort.listen((message) async {
    if (message is Map<String, dynamic>) {
      final type = message['type'] as String?;
      final data = message['data'];
      final responsePort = message['responsePort'] as SendPort?;

      try {
        final result = await plugin.handleMessage(type!, data);
        if (responsePort != null) {
          responsePort.send({
            'type': 'response',
            'data': result,
          });
        }
      } catch (e) {
        if (responsePort != null) {
          responsePort.send({
            'type': 'error',
            'error': e.toString(),
          });
        }
      }
    }
  });

  // Send the plugin's send port back to main isolate
  mainSendPort.send(pluginPort.sendPort);
}

/// Create a plugin instance from manifest
/// This is a placeholder - in a real implementation, this would
/// dynamically load and instantiate the plugin class
Plugin _createPluginInstance(
  PluginManifest manifest,
  PluginLoadContext context,
) {
  // TODO: Implement dynamic plugin loading
  // For now, return a mock plugin
  return _MockPlugin(manifest);
}

/// Mock plugin for testing
class _MockPlugin implements Plugin {
  _MockPlugin(this.manifest);
  @override
  final PluginManifest manifest;

  @override
  Future<void> initialize() async {
    // Mock initialization
  }

  @override
  Future<void> shutdown() async {
    // Mock shutdown
  }

  @override
  Future<dynamic> handleMessage(String type, dynamic data) async {
    // Mock message handling
    return {'type': type, 'data': data, 'response': 'Mock response'};
  }
}

/// Exception thrown by the plugin isolation system
class PluginIsolationException implements Exception {
  PluginIsolationException(this.message);
  final String message;

  @override
  String toString() => 'PluginIsolationException: $message';
}
