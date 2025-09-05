import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/settings/presentation/providers/window_controls_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/window_controls.dart';

/// Position of close buttons in UI elements
enum CloseButtonPosition {
  /// Auto - use platform default (left for macOS, right for others)
  auto,

  /// Place close buttons on the left side
  left,

  /// Place close buttons on the right side
  right,
}

/// Settings for close button positions across the application
@immutable
class CloseButtonSettings {
  const CloseButtonSettings({
    this.tabClosePosition = CloseButtonPosition.auto,
    this.panelClosePosition = CloseButtonPosition.auto,
  });

  final CloseButtonPosition tabClosePosition;
  final CloseButtonPosition panelClosePosition;

  CloseButtonSettings copyWith({
    CloseButtonPosition? tabClosePosition,
    CloseButtonPosition? panelClosePosition,
  }) {
    return CloseButtonSettings(
      tabClosePosition: tabClosePosition ?? this.tabClosePosition,
      panelClosePosition: panelClosePosition ?? this.panelClosePosition,
    );
  }

  /// Get the effective position for tabs based on platform and user setting
  CloseButtonPosition get effectiveTabPosition {
    if (tabClosePosition == CloseButtonPosition.auto) {
      return Platform.isMacOS
          ? CloseButtonPosition.left
          : CloseButtonPosition.right;
    }
    return tabClosePosition;
  }

  /// Get the effective position for panels based on platform and user setting
  CloseButtonPosition get effectivePanelPosition {
    if (panelClosePosition == CloseButtonPosition.auto) {
      return Platform.isMacOS
          ? CloseButtonPosition.left
          : CloseButtonPosition.right;
    }
    return panelClosePosition;
  }

  /// Set all close buttons to left position
  CloseButtonSettings setAllToLeft() {
    return copyWith(
      tabClosePosition: CloseButtonPosition.left,
      panelClosePosition: CloseButtonPosition.left,
    );
  }

  /// Set all close buttons to right position
  CloseButtonSettings setAllToRight() {
    return copyWith(
      tabClosePosition: CloseButtonPosition.right,
      panelClosePosition: CloseButtonPosition.right,
    );
  }

  /// Set all close buttons to auto (platform default)
  CloseButtonSettings setAllToAuto() {
    return copyWith(
      tabClosePosition: CloseButtonPosition.auto,
      panelClosePosition: CloseButtonPosition.auto,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloseButtonSettings &&
          runtimeType == other.runtimeType &&
          tabClosePosition == other.tabClosePosition &&
          panelClosePosition == other.panelClosePosition;

  @override
  int get hashCode => tabClosePosition.hashCode ^ panelClosePosition.hashCode;
}

/// Notifier for managing close button settings
class CloseButtonSettingsNotifier extends StateNotifier<CloseButtonSettings> {
  CloseButtonSettingsNotifier(this.ref) : super(const CloseButtonSettings());

  final Ref ref;

  /// Set the position for tab close buttons
  void setTabClosePosition(CloseButtonPosition position) {
    state = state.copyWith(tabClosePosition: position);
  }

  /// Set the position for panel close buttons
  void setPanelClosePosition(CloseButtonPosition position) {
    state = state.copyWith(panelClosePosition: position);
  }

  /// Set all close buttons and window controls to left position
  void setAllToLeft() {
    state = state.setAllToLeft();
    // Also set window controls to left
    ref
        .read(windowControlsSettingsProvider.notifier)
        .setPlacement(WindowControlsPlacement.left);
  }

  /// Set all close buttons and window controls to right position
  void setAllToRight() {
    state = state.setAllToRight();
    // Also set window controls to right
    ref
        .read(windowControlsSettingsProvider.notifier)
        .setPlacement(WindowControlsPlacement.right);
  }

  /// Set all close buttons and window controls to auto (platform default)
  void setAllToAuto() {
    state = state.setAllToAuto();
    // Also set window controls to auto
    ref
        .read(windowControlsSettingsProvider.notifier)
        .setPlacement(WindowControlsPlacement.auto);
  }
}

/// Provider for close button settings
final closeButtonSettingsProvider =
    StateNotifierProvider<CloseButtonSettingsNotifier, CloseButtonSettings>(
  CloseButtonSettingsNotifier.new,
);
