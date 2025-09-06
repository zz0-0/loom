import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/services/keyboard_shortcuts_service.dart';

/// Provider for the keyboard shortcuts service
final keyboardShortcutsServiceProvider =
    Provider<KeyboardShortcutsService>((ref) {
  final service = KeyboardShortcutsService.instance..initialize();
  return service;
});

/// Provider for all shortcuts
final shortcutsProvider = Provider<List<KeyboardShortcut>>((ref) {
  final service = ref.watch(keyboardShortcutsServiceProvider);
  return service.getAllShortcuts();
});

/// Provider for shortcuts by category
final shortcutsByCategoryProvider =
    Provider.family<List<KeyboardShortcut>, ShortcutCategory>((ref, category) {
  final service = ref.watch(keyboardShortcutsServiceProvider);
  return service.getShortcutsByCategory(category);
});

/// Provider for a specific shortcut
final shortcutProvider =
    Provider.family<KeyboardShortcut?, String>((ref, shortcutId) {
  final service = ref.watch(keyboardShortcutsServiceProvider);
  return service.getShortcut(shortcutId);
});

/// State notifier for managing shortcut customizations
class ShortcutsNotifier extends StateNotifier<Map<String, LogicalKeySet?>> {
  ShortcutsNotifier(this._service) : super({});

  final KeyboardShortcutsService _service;

  /// Update a shortcut's key binding
  void updateShortcut(String shortcutId, LogicalKeySet? keySet) {
    _service.updateShortcutKeySet(shortcutId, keySet);
    state = {...state, shortcutId: keySet};
  }

  /// Reset a shortcut to default
  void resetShortcut(String shortcutId) {
    _service.resetShortcutToDefault(shortcutId);
    state = {...state}..remove(shortcutId);
  }

  /// Reset all shortcuts to defaults
  void resetAll() {
    _service.resetAllToDefaults();
    state = {};
  }

  /// Check if a key set conflicts with existing shortcuts
  bool hasConflict(LogicalKeySet keySet, {String? excludeShortcutId}) {
    return _service.hasConflict(keySet, excludeShortcutId: excludeShortcutId);
  }
}

/// Provider for shortcuts state management
final shortcutsStateProvider =
    StateNotifierProvider<ShortcutsNotifier, Map<String, LogicalKeySet?>>(
        (ref) {
  final service = ref.watch(keyboardShortcutsServiceProvider);
  return ShortcutsNotifier(service);
});
