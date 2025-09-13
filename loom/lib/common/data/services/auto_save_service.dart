import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auto-save service that manages automatic file saving
class AutoSaveService {
  AutoSaveService();

  final Map<String, Timer?> _autoSaveTimers = {};
  final Map<String, VoidCallback?> _saveCallbacks = {};
  final Map<String, bool> _hasUnsavedChanges = {};

  /// Initialize auto-save for a file
  void initializeAutoSave(
    String filePath,
    int intervalSeconds,
    VoidCallback saveCallback, {
    required bool isEnabled,
  }) {
    // Clean up existing timer
    _cleanupFile(filePath);

    _saveCallbacks[filePath] = saveCallback;
    _hasUnsavedChanges[filePath] = false;

    if (isEnabled) {
      _startAutoSaveTimer(filePath, intervalSeconds);
    }
  }

  /// Mark that a file has unsaved changes
  void markUnsavedChanges(String filePath) {
    _hasUnsavedChanges[filePath] = true;
  }

  /// Mark that a file has been saved
  void markChangesSaved(String filePath) {
    _hasUnsavedChanges[filePath] = false;
  }

  /// Update auto-save settings for a file
  void updateSettings(
    String filePath,
    int intervalSeconds, {
    required bool isEnabled,
  }) {
    _cleanupFile(filePath);

    if (isEnabled) {
      _startAutoSaveTimer(filePath, intervalSeconds);
    }
  }

  /// Manually trigger auto-save for a file
  Future<void> saveNow(String filePath) async {
    if ((_hasUnsavedChanges[filePath] ?? false) &&
        _saveCallbacks[filePath] != null) {
      try {
        _saveCallbacks[filePath]!();
        _hasUnsavedChanges[filePath] = false;
      } catch (e) {
        debugPrint('Auto-save failed for $filePath: $e');
      }
    }
  }

  /// Clean up resources for a file
  void cleanupFile(String filePath) {
    _cleanupFile(filePath);
  }

  void _startAutoSaveTimer(String filePath, int intervalSeconds) {
    _autoSaveTimers[filePath]?.cancel();

    _autoSaveTimers[filePath] = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (timer) => _onAutoSaveTimer(filePath),
    );
  }

  void _onAutoSaveTimer(String filePath) {
    if (_hasUnsavedChanges[filePath] ?? false) {
      saveNow(filePath);
    }
  }

  void _cleanupFile(String filePath) {
    _autoSaveTimers[filePath]?.cancel();
    _autoSaveTimers.remove(filePath);
    _saveCallbacks.remove(filePath);
    _hasUnsavedChanges.remove(filePath);
  }

  /// Dispose of all resources
  void dispose() {
    for (final timer in _autoSaveTimers.values) {
      timer?.cancel();
    }
    _autoSaveTimers.clear();
    _saveCallbacks.clear();
    _hasUnsavedChanges.clear();
  }
}

/// Provider for the auto-save service
final autoSaveServiceProvider = Provider<AutoSaveService>((ref) {
  return AutoSaveService();
});
