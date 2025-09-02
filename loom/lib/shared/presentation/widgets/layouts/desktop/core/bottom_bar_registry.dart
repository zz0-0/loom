import 'package:flutter/material.dart';

/// Interface for registering bottom bar items
abstract class BottomBarItem {
  String get id;
  Widget build(BuildContext context);
  int get priority; // Lower numbers appear first
}

/// Registry for bottom bar items
class BottomBarRegistry {
  static final BottomBarRegistry _instance = BottomBarRegistry._internal();
  factory BottomBarRegistry() => _instance;
  BottomBarRegistry._internal();

  final List<BottomBarItem> _items = [];

  /// Register a bottom bar item
  void registerItem(BottomBarItem item) {
    _items.removeWhere((existing) => existing.id == item.id);
    _items.add(item);
    _items.sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// Register multiple bottom bar items
  void registerItems(List<BottomBarItem> items) {
    for (final item in items) {
      registerItem(item);
    }
  }

  /// Get all registered bottom bar items
  List<BottomBarItem> get items => List.unmodifiable(_items);

  /// Clear all registrations
  void clear() {
    _items.clear();
  }
}
