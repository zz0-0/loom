import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/repositories/settings_repository_impl.dart';
import 'package:loom/features/explorer/domain/repositories/workspace_repository.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';

// Settings repository provider
final settingsRepositoryProvider = Provider<WorkspaceSettingsRepository>(
  (ref) => WorkspaceSettingsRepositoryImpl(),
);

// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<AdaptiveThemeMode> {
  ThemeModeNotifier(this._settingsRepository) : super(AdaptiveThemeMode.system);

  final WorkspaceSettingsRepository _settingsRepository;

  void setLight() {
    state = AdaptiveThemeMode.light;
    _saveSettings();
  }

  void setDark() {
    state = AdaptiveThemeMode.dark;
    _saveSettings();
  }

  void setSystem() {
    state = AdaptiveThemeMode.system;
    _saveSettings();
  }

  void toggle() {
    state = state == AdaptiveThemeMode.light
        ? AdaptiveThemeMode.dark
        : AdaptiveThemeMode.light;
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    try {
      final currentSettings = await _settingsRepository.loadSettings();
      final themeString = _adaptiveThemeModeToString(state);
      final updatedSettings = currentSettings.copyWith(theme: themeString);
      await _settingsRepository.saveSettings(updatedSettings);
    } catch (e) {
      // Log error but don't crash the app
      debugPrint('Failed to save theme settings: $e');
    }
  }

  String _adaptiveThemeModeToString(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.light:
        return 'light';
      case AdaptiveThemeMode.dark:
        return 'dark';
      case AdaptiveThemeMode.system:
        return 'system';
    }
  }

  AdaptiveThemeMode _stringToAdaptiveThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return AdaptiveThemeMode.light;
      case 'dark':
        return AdaptiveThemeMode.dark;
      case 'system':
        return AdaptiveThemeMode.system;
      default:
        return AdaptiveThemeMode.system;
    }
  }

  Future<void> loadSavedTheme() async {
    try {
      final settings = await _settingsRepository.loadSettings();
      state = _stringToAdaptiveThemeMode(settings.theme);
    } catch (e) {
      // Use system default if loading fails
      state = AdaptiveThemeMode.system;
      debugPrint('Failed to load theme settings: $e');
    }
  }
}

// Theme providers
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AdaptiveThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(settingsRepositoryProvider)),
);

final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.createLightTheme();
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.createDarkTheme();
});

// UI State providers
class UIState {
  const UIState({
    this.isSidebarCollapsed = false,
    this.isSidePanelVisible = false,
    this.selectedSidebarItem,
    this.openedFile,
  });
  final bool isSidebarCollapsed;
  final bool isSidePanelVisible;
  final String? selectedSidebarItem;
  final String? openedFile;

  UIState copyWith({
    bool? isSidebarCollapsed,
    bool? isSidePanelVisible,
    String? selectedSidebarItem,
    String? openedFile,
    bool clearOpenedFile = false,
  }) {
    return UIState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      isSidePanelVisible: isSidePanelVisible ?? this.isSidePanelVisible,
      selectedSidebarItem: selectedSidebarItem ?? this.selectedSidebarItem,
      openedFile: clearOpenedFile ? null : (openedFile ?? this.openedFile),
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
    state = state.copyWith(clearOpenedFile: true);
  }
}

final uiStateProvider = StateNotifierProvider<UIStateNotifier, UIState>(
  (ref) => UIStateNotifier(),
);
