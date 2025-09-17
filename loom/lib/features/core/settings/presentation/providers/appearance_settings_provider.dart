import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Provider for appearance settings
final appearanceSettingsProvider =
    StateNotifierProvider<AppearanceSettingsNotifier, AppearanceSettings>(
        (ref) {
  return AppearanceSettingsNotifier();
});

/// Provider for animation durations based on current animation speed setting
final animationDurationsProvider = Provider<AnimationDurations>((ref) {
  final appearanceSettings = ref.watch(appearanceSettingsProvider);
  return AnimationDurations.fromSpeed(appearanceSettings.animationSpeed);
});

/// Animation durations class that provides scaled durations based on speed setting
class AnimationDurations {
  const AnimationDurations({
    required this.fast,
    required this.normal,
    required this.slow,
    required this.slower,
  });
  // Factory constructor that creates durations based on speed setting
  factory AnimationDurations.fromSpeed(String speed) {
    final multiplier = _getSpeedMultiplier(speed);

    return AnimationDurations(
      fast: _scaleDuration(_fastBase, multiplier),
      normal: _scaleDuration(_normalBase, multiplier),
      slow: _scaleDuration(_slowBase, multiplier),
      slower: _scaleDuration(_slowerBase, multiplier),
    );
  }

  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Duration slower;

  // Base durations for 'normal' speed
  static const Duration _fastBase = Duration(milliseconds: 150);
  static const Duration _normalBase = Duration(milliseconds: 250);
  static const Duration _slowBase = Duration(milliseconds: 350);
  static const Duration _slowerBase = Duration(milliseconds: 500);

  // Get speed multiplier based on animation speed setting
  static double _getSpeedMultiplier(String speed) {
    switch (speed) {
      case 'fast':
        return 0.6; // 60% of normal speed
      case 'normal':
        return 1; // 100% of normal speed
      case 'slow':
        return 1.5; // 150% of normal speed
      case 'disabled':
        return 0; // Instant (no animation)
      default:
        return 1;
    }
  }

  // Scale duration by multiplier, handling disabled case
  static Duration _scaleDuration(Duration base, double multiplier) {
    if (multiplier == 0.0) {
      return Duration.zero; // Instant for disabled animations
    }
    return Duration(milliseconds: (base.inMilliseconds * multiplier).round());
  }
}

/// Appearance settings notifier
class AppearanceSettingsNotifier extends StateNotifier<AppearanceSettings> {
  AppearanceSettingsNotifier() : super(const AppearanceSettings());

  void setCompactMode({required bool value}) {
    state = state.copyWith(compactMode: value);
  }

  void setTheme(String value) {
    state = state.copyWith(theme: value);
  }

  void setShowMenuIcons({required bool value}) {
    state = state.copyWith(showMenuIcons: value);
  }

  void setAnimationSpeed(String value) {
    state = state.copyWith(animationSpeed: value);
  }

  void setSidebarTransparency({required bool value}) {
    state = state.copyWith(sidebarTransparency: value);
  }
}
