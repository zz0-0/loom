import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loom/shared/services/keyboard_shortcuts_service.dart';

/// Provider for the keyboard shortcuts service
final shortcutsServiceProvider = Provider<KeyboardShortcutsService>((ref) {
  final service = KeyboardShortcutsService.instance;
  service.initialize();
  return service;
});

/// Provider for all shortcuts
final shortcutsProvider = Provider<List<KeyboardShortcut>>((ref) {
  final service = ref.watch(shortcutsServiceProvider);
  return service.getAllShortcuts();
});

/// Provider for shortcuts by category
final shortcutsByCategoryProvider =
    Provider.family<List<KeyboardShortcut>, ShortcutCategory>((ref, category) {
  final service = ref.watch(shortcutsServiceProvider);
  return service.getShortcutsByCategory(category);
});

/// State notifier for managing shortcuts state
class ShortcutsNotifier extends StateNotifier<Map<String, KeyboardShortcut>> {
  ShortcutsNotifier(this._service) : super({}) {
    _initializeShortcuts();
  }

  final KeyboardShortcutsService _service;

  void _initializeShortcuts() {
    final shortcuts = _service.getAllShortcuts();
    state = {for (final shortcut in shortcuts) shortcut.id: shortcut};
  }

  /// Update a shortcut's key binding
  void updateShortcutKeySet(String shortcutId, LogicalKeySet? newKeySet) {
    _service.updateShortcutKeySet(shortcutId, newKeySet);
    final updatedShortcut = _service.getShortcut(shortcutId);
    if (updatedShortcut != null) {
      state = {...state, shortcutId: updatedShortcut};
    }
  }

  /// Reset shortcut to default
  void resetShortcutToDefault(String shortcutId) {
    _service.resetShortcutToDefault(shortcutId);
    final updatedShortcut = _service.getShortcut(shortcutId);
    if (updatedShortcut != null) {
      state = {...state, shortcutId: updatedShortcut};
    }
  }

  /// Reset all shortcuts to defaults
  void resetAllToDefaults() {
    _service.resetAllToDefaults();
    _initializeShortcuts();
  }

  /// Check if a key set conflicts with existing shortcuts
  bool hasConflict(LogicalKeySet keySet, {String? excludeShortcutId}) {
    return _service.hasConflict(keySet, excludeShortcutId: excludeShortcutId);
  }
}

/// State provider for shortcuts state management
final shortcutsStateProvider =
    StateNotifierProvider<ShortcutsNotifier, Map<String, KeyboardShortcut>>(
        (ref) {
  final service = ref.watch(shortcutsServiceProvider);
  return ShortcutsNotifier(service);
});
