import 'package:flutter/material.dart';

/// Interface for registering top bar items
abstract class TopBarItem {
  String get id;
  Widget build(BuildContext context);
  TopBarPosition get position;
  int get priority; // Lower numbers appear first within their position
}

/// Position of top bar items
enum TopBarPosition {
  left,
  center,
  right,
}

/// Registry for top bar items
class TopBarRegistry {
  factory TopBarRegistry() => _instance;
  TopBarRegistry._internal();
  static final TopBarRegistry _instance = TopBarRegistry._internal();

  final List<TopBarItem> _items = [];

  /// Register a top bar item
  void registerItem(TopBarItem item) {
    _items.removeWhere((existing) => existing.id == item.id);
    _items.add(item);
    _items.sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// Register multiple top bar items
  void registerItems(List<TopBarItem> items) {
    for (final item in items) {
      registerItem(item);
    }
  }

  /// Get items by position
  List<TopBarItem> getItemsByPosition(TopBarPosition position) {
    return _items.where((item) => item.position == position).toList();
  }

  /// Get all registered top bar items
  List<TopBarItem> get items => List.unmodifiable(_items);

  /// Clear all registrations
  void clear() {
    _items.clear();
  }
}
