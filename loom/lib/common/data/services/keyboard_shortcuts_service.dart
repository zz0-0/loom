import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loom/common/index.dart';

/// Service for managing keyboard shortcuts
class KeyboardShortcutsService {
  KeyboardShortcutsService._();

  static final KeyboardShortcutsService _instance =
      KeyboardShortcutsService._();
  static KeyboardShortcutsService get instance => _instance;

  final Map<String, KeyboardShortcut> _shortcuts = {};
  final Map<LogicalKeySet, String> _keySetToShortcutId = {};

  /// Initialize with default shortcuts
  void initialize() {
    _registerDefaultShortcuts();
    _buildKeySetMap();
  }

  /// Register a shortcut
  void registerShortcut(KeyboardShortcut shortcut) {
    _shortcuts[shortcut.id] = shortcut;
    _keySetToShortcutId[shortcut.effectiveKeySet] = shortcut.id;
  }

  /// Update a shortcut's key binding
  void updateShortcutKeySet(String shortcutId, LogicalKeySet? newKeySet) {
    final shortcut = _shortcuts[shortcutId];
    if (shortcut != null) {
      // Remove old key set mapping
      _keySetToShortcutId.remove(shortcut.effectiveKeySet);

      // Update shortcut
      final updatedShortcut = shortcut.copyWith(keySet: newKeySet);
      _shortcuts[shortcutId] = updatedShortcut;

      // Add new key set mapping if not null
      if (newKeySet != null) {
        _keySetToShortcutId[newKeySet] = shortcutId;
      }
    }
  }

  /// Get all shortcuts
  List<KeyboardShortcut> getAllShortcuts() {
    return _shortcuts.values.toList();
  }

  /// Get shortcuts by category
  List<KeyboardShortcut> getShortcutsByCategory(ShortcutCategory category) {
    return _shortcuts.values.where((s) => s.category == category).toList();
  }

  /// Get shortcut by ID
  KeyboardShortcut? getShortcut(String id) {
    return _shortcuts[id];
  }

  /// Get shortcut by key set
  KeyboardShortcut? getShortcutByKeySet(LogicalKeySet keySet) {
    final shortcutId = _keySetToShortcutId[keySet];
    return shortcutId != null ? _shortcuts[shortcutId] : null;
  }

  /// Check if a key set conflicts with existing shortcuts
  bool hasConflict(LogicalKeySet keySet, {String? excludeShortcutId}) {
    final existingShortcutId = _keySetToShortcutId[keySet];
    if (existingShortcutId == null) return false;
    if (excludeShortcutId != null && existingShortcutId == excludeShortcutId) {
      return false;
    }
    return true;
  }

  /// Reset shortcut to default
  void resetShortcutToDefault(String shortcutId) {
    final shortcut = _shortcuts[shortcutId];
    if (shortcut != null) {
      updateShortcutKeySet(shortcutId, null);
    }
  }

  /// Reset all shortcuts to defaults
  void resetAllToDefaults() {
    for (final shortcut in _shortcuts.values) {
      updateShortcutKeySet(shortcut.id, null);
    }
  }

  /// Register default shortcuts
  void _registerDefaultShortcuts() {
    // File Operations
    registerShortcut(
      KeyboardShortcut(
        id: 'file.save',
        name: 'Save File',
        description: 'Save the current file',
        category: ShortcutCategory.file,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyS,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'file.new',
        name: 'New File',
        description: 'Create a new file',
        category: ShortcutCategory.file,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyN,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'file.open',
        name: 'Open File',
        description: 'Open an existing file',
        category: ShortcutCategory.file,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyO,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'file.export',
        name: 'Export File',
        description: 'Export the current file',
        category: ShortcutCategory.file,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyE,
        ),
      ),
    );

    // Text Editing
    registerShortcut(
      KeyboardShortcut(
        id: 'edit.undo',
        name: 'Undo',
        description: 'Undo the last action',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyZ,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.redo',
        name: 'Redo',
        description: 'Redo the last undone action',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyY,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.copy',
        name: 'Copy',
        description: 'Copy selected text',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyC,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.paste',
        name: 'Paste',
        description: 'Paste from clipboard',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyV,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.cut',
        name: 'Cut',
        description: 'Cut selected text',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyX,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.selectAll',
        name: 'Select All',
        description: 'Select all text',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyA,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.indent',
        name: 'Indent',
        description: 'Indent selected lines',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(LogicalKeyboardKey.tab),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.dedent',
        name: 'Dedent',
        description: 'Dedent selected lines',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.tab,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.fold',
        name: 'Fold Code',
        description: 'Fold the current code block',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.bracketLeft,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'edit.unfold',
        name: 'Unfold Code',
        description: 'Unfold the current code block',
        category: ShortcutCategory.edit,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.bracketRight,
        ),
      ),
    );

    // Search & Find
    registerShortcut(
      KeyboardShortcut(
        id: 'search.find',
        name: 'Find',
        description: 'Find text in current file',
        category: ShortcutCategory.search,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyF,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'search.replace',
        name: 'Replace',
        description: 'Find and replace text',
        category: ShortcutCategory.search,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyH,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'search.global',
        name: 'Global Search',
        description: 'Search across all files',
        category: ShortcutCategory.search,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyF,
        ),
      ),
    );

    // View & Navigation
    registerShortcut(
      KeyboardShortcut(
        id: 'view.sidebar',
        name: 'Toggle Sidebar',
        description: 'Show/hide the sidebar',
        category: ShortcutCategory.view,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyB,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'view.fullscreen',
        name: 'Toggle Fullscreen',
        description: 'Enter/exit fullscreen mode',
        category: ShortcutCategory.view,
        defaultKeySet: LogicalKeySet(LogicalKeyboardKey.f11),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'navigation.gotoLine',
        name: 'Go to Line',
        description: 'Navigate to a specific line number',
        category: ShortcutCategory.view,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyG,
        ),
      ),
    );

    // Window Management
    registerShortcut(
      KeyboardShortcut(
        id: 'window.closeTab',
        name: 'Close Tab',
        description: 'Close the current tab',
        category: ShortcutCategory.window,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyW,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'window.nextTab',
        name: 'Next Tab',
        description: 'Switch to next tab',
        category: ShortcutCategory.window,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.tab,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'window.previousTab',
        name: 'Previous Tab',
        description: 'Switch to previous tab',
        category: ShortcutCategory.window,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.tab,
        ),
      ),
    );

    registerShortcut(
      KeyboardShortcut(
        id: 'window.newTab',
        name: 'New Tab',
        description: 'Open a new tab',
        category: ShortcutCategory.window,
        defaultKeySet: LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyT,
        ),
      ),
    );
  }

  /// Build the key set to shortcut ID mapping
  void _buildKeySetMap() {
    _keySetToShortcutId.clear();
    for (final shortcut in _shortcuts.values) {
      _keySetToShortcutId[shortcut.effectiveKeySet] = shortcut.id;
    }
  }
}
