import 'package:flutter/material.dart';

/// Represents a keyboard shortcut
class KeyboardShortcut {
  const KeyboardShortcut({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.defaultKeySet,
    this.keySet,
    this.action,
  });

  final String id;
  final String name;
  final String description;
  final ShortcutCategory category;
  final LogicalKeySet defaultKeySet;
  final LogicalKeySet? keySet;
  final VoidCallback? action;

  /// Get the effective key set (custom or default)
  LogicalKeySet get effectiveKeySet => keySet ?? defaultKeySet;

  /// Create a copy with new key set
  KeyboardShortcut copyWith({LogicalKeySet? keySet}) {
    return KeyboardShortcut(
      id: id,
      name: name,
      description: description,
      category: category,
      defaultKeySet: defaultKeySet,
      keySet: keySet,
      action: action,
    );
  }
}

/// Categories for organizing shortcuts
enum ShortcutCategory {
  file('File Operations'),
  edit('Text Editing'),
  view('View & Navigation'),
  search('Search & Find'),
  window('Window Management'),
  developer('Developer Tools');

  const ShortcutCategory(this.displayName);
  final String displayName;
}
