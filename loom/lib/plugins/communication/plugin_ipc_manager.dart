import 'dart:async';
import 'dart:isolate';

/// Manages inter-process communication between main app and plugins
class PluginIPCManager {
  final Map<String, SendPort> _pluginSendPorts = {};
  final Map<String, StreamController<IPCMessage>> _messageControllers = {};
  final Map<String, Completer<dynamic>> _pendingRequests = {};

  /// Register a plugin's send port
  void registerPlugin(String pluginId, SendPort sendPort) {
    _pluginSendPorts[pluginId] = sendPort;
    _messageControllers[pluginId] = StreamController<IPCMessage>.broadcast();
  }

  /// Unregister a plugin
  void unregisterPlugin(String pluginId) {
    _pluginSendPorts.remove(pluginId);
    _messageControllers[pluginId]?.close();
    _messageControllers.remove(pluginId);

    // Cancel any pending requests
    _pendingRequests.remove(pluginId);
  }

  /// Send a message to a plugin
  Future<dynamic> sendMessage(String pluginId, IPCMessage message) async {
    final sendPort = _pluginSendPorts[pluginId];
    if (sendPort == null) {
      throw IPCException('Plugin $pluginId is not registered');
    }

    final completer = Completer<dynamic>();
    final requestId = _generateRequestId();

    _pendingRequests[requestId] = completer;

    // Create response port for this request
    final responsePort = ReceivePort();
    responsePort.listen((response) {
      responsePort.close();
      _pendingRequests.remove(requestId);

      if (response is IPCMessage) {
        if (response.type == IPCMessageType.error) {
          completer.completeError(IPCException(response.data.toString()));
        } else {
          completer.complete(response.data);
        }
      } else {
        completer.complete(response);
      }
    });

    // Send message with response port
    sendPort.send(
      IPCMessage(
        type: message.type,
        data: message.data,
        requestId: requestId,
        responsePort: responsePort.sendPort,
      ),
    );

    // Set timeout
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        responsePort.close();
        _pendingRequests.remove(requestId);
        throw IPCException('Request to plugin $pluginId timed out');
      },
    );
  }

  /// Broadcast a message to all registered plugins
  Future<void> broadcastMessage(IPCMessage message) async {
    final futures = <Future<void>>[];

    for (final pluginId in _pluginSendPorts.keys) {
      futures.add(
        sendMessage(pluginId, message).catchError((Object error) {
          // Log error but don't fail the broadcast
          print('Failed to send message to plugin $pluginId: $error');
          return null;
        }),
      );
    }

    await Future.wait(futures);
  }

  /// Send a message to multiple specific plugins
  Future<Map<String, dynamic>> sendMessageToMultiple(
    List<String> pluginIds,
    IPCMessage message,
  ) async {
    final results = <String, dynamic>{};
    final futures = <Future<void>>[];

    for (final pluginId in pluginIds) {
      final future = sendMessage(pluginId, message).then((result) {
        results[pluginId] = result;
      }).catchError((Object error) {
        results[pluginId] = {'error': error.toString()};
        return null;
      });
      futures.add(future);
    }

    await Future.wait(futures);
    return results;
  }

  /// Listen for messages from a specific plugin
  Stream<IPCMessage> listenToPlugin(String pluginId) {
    return _messageControllers[pluginId]?.stream ?? const Stream.empty();
  }

  /// Handle incoming message from a plugin
  void handleIncomingMessage(String pluginId, IPCMessage message) {
    final controller = _messageControllers[pluginId];
    if (controller != null) {
      controller.add(message);
    }

    // Handle response messages
    if (message.requestId != null) {
      final completer = _pendingRequests[message.requestId];
      if (completer != null) {
        if (message.type == IPCMessageType.error) {
          completer.completeError(IPCException(message.data.toString()));
        } else {
          completer.complete(message.data);
        }
        _pendingRequests.remove(message.requestId);
      }
    }
  }

  /// Get list of registered plugin IDs
  List<String> getRegisteredPlugins() {
    return _pluginSendPorts.keys.toList();
  }

  /// Check if a plugin is registered
  bool isPluginRegistered(String pluginId) {
    return _pluginSendPorts.containsKey(pluginId);
  }

  String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_pendingRequests.length}';
  }
}

/// Represents a message in the IPC system
class IPCMessage {
  const IPCMessage({
    required this.type,
    required this.data,
    this.requestId,
    this.responsePort,
    this.metadata,
  });

  factory IPCMessage.fromJson(Map<String, dynamic> json) {
    return IPCMessage(
      type: IPCMessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => IPCMessageType.custom,
      ),
      data: json['data'],
      requestId: json['requestId'] as String?,
      responsePort: json['responsePort'] as SendPort?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Create a response message
  factory IPCMessage.response(String requestId, dynamic data) {
    return IPCMessage(
      type: IPCMessageType.response,
      data: data,
      requestId: requestId,
    );
  }

  /// Create an error message
  factory IPCMessage.error(String requestId, String error) {
    return IPCMessage(
      type: IPCMessageType.error,
      data: error,
      requestId: requestId,
    );
  }

  /// Create a command execution message
  factory IPCMessage.command(String commandId, Map<String, dynamic> args) {
    return IPCMessage(
      type: IPCMessageType.command,
      data: {'commandId': commandId, 'args': args},
    );
  }

  /// Create a file operation message
  factory IPCMessage.fileOperation(
    String operation,
    String filePath,
    dynamic data,
  ) {
    return IPCMessage(
      type: IPCMessageType.fileOperation,
      data: {'operation': operation, 'filePath': filePath, 'data': data},
    );
  }

  /// Create a UI event message
  factory IPCMessage.uiEvent(String eventType, dynamic data) {
    return IPCMessage(
      type: IPCMessageType.uiEvent,
      data: {'eventType': eventType, 'data': data},
    );
  }

  /// Create a lifecycle event message
  factory IPCMessage.lifecycleEvent(String eventType, dynamic data) {
    return IPCMessage(
      type: IPCMessageType.lifecycle,
      data: {'eventType': eventType, 'data': data},
    );
  }
  final IPCMessageType type;
  final dynamic data;
  final String? requestId;
  final SendPort? responsePort;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'data': data,
      'requestId': requestId,
      'responsePort': responsePort,
      'metadata': metadata,
    };
  }
}

/// Types of IPC messages
enum IPCMessageType {
  command,
  fileOperation,
  uiEvent,
  lifecycle,
  response,
  error,
  custom,
}

/// Exception thrown by the IPC system
class IPCException implements Exception {
  IPCException(this.message);
  final String message;

  @override
  String toString() => 'IPCException: $message';
}

/// Middleware for processing IPC messages
abstract class IPCMiddleware {
  Future<IPCMessage> processMessage(IPCMessage message);
}

/// Chain of middleware for processing messages
class IPCMiddlewareChain {
  IPCMiddlewareChain(this._middlewares);
  final List<IPCMiddleware> _middlewares;

  Future<IPCMessage> process(IPCMessage message) async {
    var currentMessage = message;

    for (final middleware in _middlewares) {
      currentMessage = await middleware.processMessage(currentMessage);
    }

    return currentMessage;
  }
}

/// Logging middleware for IPC messages
class IPCLoggingMiddleware implements IPCMiddleware {
  @override
  Future<IPCMessage> processMessage(IPCMessage message) async {
    print('[IPC] ${message.type} - ${message.data}');
    return message;
  }
}

/// Validation middleware for IPC messages
class IPCValidationMiddleware implements IPCMiddleware {
  @override
  Future<IPCMessage> processMessage(IPCMessage message) async {
    // TODO: Add message validation logic
    return message;
  }
}
