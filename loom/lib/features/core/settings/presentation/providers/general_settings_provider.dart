import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/domain/entities/settings_entities.dart';

/// Provider for general settings
final generalSettingsProvider =
    StateNotifierProvider<GeneralSettingsNotifier, GeneralSettings>((ref) {
  return GeneralSettingsNotifier();
});

/// Provider for auto-save functionality
final autoSaveProvider =
    StateNotifierProvider<AutoSaveNotifier, AutoSaveState>((ref) {
  final generalSettings = ref.watch(generalSettingsProvider);
  return AutoSaveNotifier(generalSettings.autoSave);
});

/// Provider for appearance settings
final appearanceSettingsProvider =
    StateNotifierProvider<AppearanceSettingsNotifier, AppearanceSettings>(
        (ref) {
  return AppearanceSettingsNotifier();
});

/// Provider for interface settings
final interfaceSettingsProvider =
    StateNotifierProvider<InterfaceSettingsNotifier, InterfaceSettings>((ref) {
  return InterfaceSettingsNotifier();
});

/// General settings notifier
class GeneralSettingsNotifier extends StateNotifier<GeneralSettings> {
  GeneralSettingsNotifier()
      : super(
          const GeneralSettings(),
        );

  void setAutoSave(bool value) {
    state = state.copyWith(autoSave: value);
  }

  void setConfirmOnExit(bool value) {
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
  AutoSaveNotifier(bool initialEnabled)
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
  void setSaveCallback(VoidCallback callback) {
    _onSaveCallback = callback;
  }

  /// Enable or disable auto-save
  void setEnabled(bool enabled) {
    if (enabled == state.isEnabled) return;

    state = state.copyWith(isEnabled: enabled);

    if (enabled) {
      _startAutoSaveTimer();
    } else {
      _stopAutoSaveTimer();
    }
  }

  /// Set the auto-save interval in seconds
  void setInterval(int seconds) {
    state = state.copyWith(intervalSeconds: seconds);
    if (state.isEnabled) {
      _restartAutoSaveTimer();
    }
  }

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

  void _restartAutoSaveTimer() {
    _stopAutoSaveTimer();
    _startAutoSaveTimer();
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

/// Appearance settings notifier
class AppearanceSettingsNotifier extends StateNotifier<AppearanceSettings> {
  AppearanceSettingsNotifier() : super(const AppearanceSettings());

  void setCompactMode(bool value) {
    state = state.copyWith(compactMode: value);
  }

  void setFontSize(double value) {
    state = state.copyWith(fontSize: value);
  }

  void setTheme(String value) {
    state = state.copyWith(theme: value);
  }
}

/// Interface settings notifier
class InterfaceSettingsNotifier extends StateNotifier<InterfaceSettings> {
  InterfaceSettingsNotifier() : super(const InterfaceSettings());

  void setShowSidebar(bool value) {
    state = state.copyWith(showSidebar: value);
  }

  void setShowBottomBar(bool value) {
    state = state.copyWith(showBottomBar: value);
  }

  void setSidebarPosition(String value) {
    state = state.copyWith(sidebarPosition: value);
  }

  void setCloseButtonPosition(String value) {
    state = state.copyWith(closeButtonPosition: value);
  }
}
