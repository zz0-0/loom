import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Provider for general settings
final generalSettingsProvider =
    StateNotifierProvider<GeneralSettingsNotifier, GeneralSettings>((ref) {
  return GeneralSettingsNotifier();
});

/// Provider for auto-save functionality
final autoSaveProvider =
    StateNotifierProvider<AutoSaveNotifier, AutoSaveState>((ref) {
  final generalSettings = ref.watch(generalSettingsProvider);
  return AutoSaveNotifier(initialEnabled: generalSettings.autoSave);
});

/// General settings notifier
class GeneralSettingsNotifier extends StateNotifier<GeneralSettings> {
  GeneralSettingsNotifier()
      : super(
          const GeneralSettings(),
        );

  void setAutoSave({required bool value}) {
    state = state.copyWith(autoSave: value);
  }

  void setConfirmOnExit({required bool value}) {
    state = state.copyWith(confirmOnExit: value);
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
  }
}

/// Auto-save state
class AutoSaveState {
  const AutoSaveState({
    this.isEnabled = true,
    this.intervalSeconds = 30,
    this.lastSaveTime,
    this.isSaving = false,
    this.hasUnsavedChanges = false,
  });

  final bool isEnabled;
  final int intervalSeconds;
  final DateTime? lastSaveTime;
  final bool isSaving;
  final bool hasUnsavedChanges;

  AutoSaveState copyWith({
    bool? isEnabled,
    int? intervalSeconds,
    DateTime? lastSaveTime,
    bool? isSaving,
    bool? hasUnsavedChanges,
  }) {
    return AutoSaveState(
      isEnabled: isEnabled ?? this.isEnabled,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      lastSaveTime: lastSaveTime ?? this.lastSaveTime,
      isSaving: isSaving ?? this.isSaving,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}

/// Auto-save notifier that manages the auto-save timer and state
class AutoSaveNotifier extends StateNotifier<AutoSaveState> {
  AutoSaveNotifier({required bool initialEnabled})
      : super(AutoSaveState(isEnabled: initialEnabled)) {
    _initialize();
  }

  Timer? _autoSaveTimer;
  VoidCallback? _onSaveCallback;

  void _initialize() {
    if (state.isEnabled) {
      _startAutoSaveTimer();
    }
  }

  /// Set the save callback that will be called when auto-saving
  // ignore: use_setters_to_change_properties
  void setSaveCallback(VoidCallback callback) {
    _onSaveCallback = callback;
  }

  /// Enable or disable auto-save
  bool get isEnabled => state.isEnabled;

  set isEnabled(bool value) {
    if (value == state.isEnabled) return;
    state = state.copyWith(isEnabled: value);

    if (value) {
      _startAutoSaveTimer();
    } else {
      _stopAutoSaveTimer();
    }
  }

  /// Set the auto-save interval in seconds
  set interval(int value) {
    state = state.copyWith(intervalSeconds: value);
  }

  int get interval => state.intervalSeconds;

  /// Mark that there are unsaved changes
  void markUnsavedChanges() {
    state = state.copyWith(hasUnsavedChanges: true);
  }

  /// Mark that changes have been saved
  void markChangesSaved() {
    state = state.copyWith(
      hasUnsavedChanges: false,
      lastSaveTime: DateTime.now(),
    );
  }

  /// Manually trigger auto-save
  Future<void> saveNow() async {
    if (!state.hasUnsavedChanges || _onSaveCallback == null) return;

    state = state.copyWith(isSaving: true);

    try {
      _onSaveCallback!();
      state = state.copyWith(
        isSaving: false,
        hasUnsavedChanges: false,
        lastSaveTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }

  void _startAutoSaveTimer() {
    _stopAutoSaveTimer(); // Ensure no duplicate timers

    _autoSaveTimer = Timer.periodic(
      Duration(seconds: state.intervalSeconds),
      _onAutoSaveTimer,
    );
  }

  void _stopAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }

  void _onAutoSaveTimer(Timer timer) {
    if (state.hasUnsavedChanges && !state.isSaving) {
      saveNow();
    }
  }

  @override
  void dispose() {
    _stopAutoSaveTimer();
    super.dispose();
  }
}
