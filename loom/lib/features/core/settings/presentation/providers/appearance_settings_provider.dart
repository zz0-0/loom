import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Provider for appearance settings
final appearanceSettingsProvider =
    StateNotifierProvider<AppearanceSettingsNotifier, AppearanceSettings>(
        (ref) {
  return AppearanceSettingsNotifier();
});

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
