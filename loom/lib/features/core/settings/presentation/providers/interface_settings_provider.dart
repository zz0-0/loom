import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Provider for interface settings
final interfaceSettingsProvider =
    StateNotifierProvider<InterfaceSettingsNotifier, InterfaceSettings>((ref) {
  return InterfaceSettingsNotifier();
});

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
