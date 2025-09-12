import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/window_controls.dart';

/// Order of window control buttons
enum WindowControlsOrder {
  /// Standard Windows/Linux order: Minimize, Maximize, Close
  standard,

  /// macOS order: Close, Minimize, Maximize
  macOS,

  /// Reverse of standard: Close, Maximize, Minimize
  reverse,
}

/// Settings for window controls appearance and behavior
class WindowControlsSettings {
  const WindowControlsSettings({
    this.placement = WindowControlsPlacement.auto,
    this.showControls = true,
    this.order = WindowControlsOrder.standard,
  });

  final WindowControlsPlacement placement;
  final bool showControls;
  final WindowControlsOrder order;

  WindowControlsSettings copyWith({
    WindowControlsPlacement? placement,
    bool? showControls,
    WindowControlsOrder? order,
  }) {
    return WindowControlsSettings(
      placement: placement ?? this.placement,
      showControls: showControls ?? this.showControls,
      order: order ?? this.order,
    );
  }

  /// Get the effective placement based on platform and user setting
  WindowControlsPlacement get effectivePlacement {
    if (placement == WindowControlsPlacement.auto) {
      return Platform.isMacOS
          ? WindowControlsPlacement.left
          : WindowControlsPlacement.right;
    }
    return placement;
  }

  /// Get the effective order based on platform and user setting
  WindowControlsOrder get effectiveOrder {
    if (order == WindowControlsOrder.standard && Platform.isMacOS) {
      return WindowControlsOrder.macOS;
    }
    return order;
  }
}

class WindowControlsSettingsNotifier
    extends StateNotifier<WindowControlsSettings> {
  WindowControlsSettingsNotifier() : super(const WindowControlsSettings());

  void setPlacement(WindowControlsPlacement placement) {
    state = state.copyWith(placement: placement);
  }

  void setOrder(WindowControlsOrder order) {
    state = state.copyWith(order: order);
  }

  void toggleControls() {
    state = state.copyWith(showControls: !state.showControls);
  }

  void setShowControls({required bool show}) {
    state = state.copyWith(showControls: show);
  }
}

final windowControlsSettingsProvider = StateNotifierProvider<
    WindowControlsSettingsNotifier, WindowControlsSettings>(
  (ref) => WindowControlsSettingsNotifier(),
);
