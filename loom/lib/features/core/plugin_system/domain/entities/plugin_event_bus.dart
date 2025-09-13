import 'dart:async';
import 'package:loom/features/core/plugin_system/domain/entities/plugin_base.dart';

/// Event bus for plugin communication
class PluginEventBus {
  final Map<String, List<PluginEventListener>> _listeners = {};
  final Map<String, StreamController<dynamic>> _streamControllers = {};

  /// Subscribe to an event
  void subscribe(String event, PluginEventListener listener) {
    _listeners.putIfAbsent(event, () => []).add(listener);
  }

  /// Unsubscribe from an event
  void unsubscribe(String event, PluginEventListener listener) {
    _listeners[event]?.remove(listener);
  }

  /// Publish an event to all subscribers
  void publish(String event, [dynamic data]) {
    final listeners = _listeners[event];
    if (listeners != null) {
      for (final listener in listeners) {
        listener(data);
      }
    }

    // Also publish to stream if it exists
    final controller = _streamControllers[event];
    if (controller != null && !controller.isClosed) {
      controller.add(data);
    }
  }

  /// Get a stream for an event (for reactive programming)
  Stream<T> stream<T>(String event) {
    // Create a stream controller for this event if it doesn't exist
    if (!_streamControllers.containsKey(event)) {
      _streamControllers[event] = StreamController<T>.broadcast();
    }

    return _streamControllers[event]!.stream as Stream<T>;
  }

  /// Dispose of all stream controllers
  void dispose() {
    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
    _listeners.clear();
  }
}
