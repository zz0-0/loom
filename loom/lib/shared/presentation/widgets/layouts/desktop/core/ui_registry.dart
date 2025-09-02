import 'package:flutter/material.dart';

/// Interface for registering sidebar items
abstract class SidebarItem {
  String get id;
  IconData get icon;
  String? get tooltip;
  Widget? buildPanel(BuildContext context);
  VoidCallback? get onPressed;
}

/// Interface for registering content areas
abstract class ContentProvider {
  String get id;
  Widget build(BuildContext context);
  bool canHandle(String? contentId);
}

/// Registry for UI components that can be dynamically registered
class UIRegistry {
  static final UIRegistry _instance = UIRegistry._internal();
  factory UIRegistry() => _instance;
  UIRegistry._internal();

  final List<SidebarItem> _sidebarItems = [];
  final List<ContentProvider> _contentProviders = [];

  /// Register a sidebar item
  void registerSidebarItem(SidebarItem item) {
    _sidebarItems.removeWhere((existing) => existing.id == item.id);
    _sidebarItems.add(item);
  }

  /// Register multiple sidebar items
  void registerSidebarItems(List<SidebarItem> items) {
    for (final item in items) {
      registerSidebarItem(item);
    }
  }

  /// Register a content provider
  void registerContentProvider(ContentProvider provider) {
    _contentProviders.removeWhere((existing) => existing.id == provider.id);
    _contentProviders.add(provider);
  }

  /// Get all registered sidebar items
  List<SidebarItem> get sidebarItems => List.unmodifiable(_sidebarItems);

  /// Get sidebar item by ID
  SidebarItem? getSidebarItem(String id) {
    try {
      return _sidebarItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get content provider that can handle the given content ID
  ContentProvider? getContentProvider(String? contentId) {
    try {
      return _contentProviders.firstWhere(
        (provider) => provider.canHandle(contentId),
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear all registrations (useful for testing)
  void clear() {
    _sidebarItems.clear();
    _contentProviders.clear();
  }
}
