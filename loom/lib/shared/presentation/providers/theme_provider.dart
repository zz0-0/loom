import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<AdaptiveThemeMode> {
  ThemeModeNotifier() : super(AdaptiveThemeMode.system);

  void setLight() => state = AdaptiveThemeMode.light;
  void setDark() => state = AdaptiveThemeMode.dark;
  void setSystem() => state = AdaptiveThemeMode.system;
  void toggle() {
    state = state == AdaptiveThemeMode.light
        ? AdaptiveThemeMode.dark
        : AdaptiveThemeMode.light;
  }
}

// Theme providers
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AdaptiveThemeMode>(
  (ref) => ThemeModeNotifier(),
);

final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.createLightTheme();
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.createDarkTheme();
});

// UI State providers
class UIState {
  final bool isSidebarCollapsed;
  final bool isSidePanelVisible;
  final String? selectedSidebarItem;
  final String? openedFile;

  const UIState({
    this.isSidebarCollapsed = false,
    this.isSidePanelVisible = true,
    this.selectedSidebarItem,
    this.openedFile,
  });

  UIState copyWith({
    bool? isSidebarCollapsed,
    bool? isSidePanelVisible,
    String? selectedSidebarItem,
    String? openedFile,
  }) {
    return UIState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      isSidePanelVisible: isSidePanelVisible ?? this.isSidePanelVisible,
      selectedSidebarItem: selectedSidebarItem ?? this.selectedSidebarItem,
      openedFile: openedFile ?? this.openedFile,
    );
  }
}

class UIStateNotifier extends StateNotifier<UIState> {
  UIStateNotifier() : super(const UIState());

  void toggleSidebar() {
    state = state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed);
  }

  void collapseSidebar() {
    state = state.copyWith(isSidebarCollapsed: true);
  }

  void expandSidebar() {
    state = state.copyWith(isSidebarCollapsed: false);
  }

  void toggleSidePanel() {
    state = state.copyWith(isSidePanelVisible: !state.isSidePanelVisible);
  }

  void showSidePanel() {
    state = state.copyWith(isSidePanelVisible: true);
  }

  void hideSidePanel() {
    state = state.copyWith(isSidePanelVisible: false);
  }

  void selectSidebarItem(String item) {
    // If clicking the same item, toggle the panel
    if (state.selectedSidebarItem == item) {
      toggleSidePanel();
    } else {
      state = state.copyWith(
        selectedSidebarItem: item,
        isSidePanelVisible: true,
      );
    }
  }

  void openFile(String filePath) {
    state = state.copyWith(openedFile: filePath);
  }

  void closeFile() {
    state = state.copyWith(openedFile: null);
  }
}

final uiStateProvider = StateNotifierProvider<UIStateNotifier, UIState>(
  (ref) => UIStateNotifier(),
);
