import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<AdaptiveThemeMode> {
  ThemeModeNotifier(this._settingsRepository) : super(AdaptiveThemeMode.system);

  final SharedSettingsRepository _settingsRepository;

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
      final themeString = _adaptiveThemeModeToString(state);
      await _settingsRepository.setTheme(themeString);
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
      final themeString = await _settingsRepository.getTheme();
      state = _stringToAdaptiveThemeMode(themeString);
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
  (ref) => ThemeModeNotifier(ref.watch(sharedSettingsRepositoryProvider)),
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
    this.sidePanelWidth = 320.0,
  });
  final bool isSidebarCollapsed;
  final bool isSidePanelVisible;
  final String? selectedSidebarItem;
  final String? openedFile;
  final double sidePanelWidth;

  UIState copyWith({
    bool? isSidebarCollapsed,
    bool? isSidePanelVisible,
    String? selectedSidebarItem,
    String? openedFile,
    double? sidePanelWidth,
    bool clearOpenedFile = false,
  }) {
    return UIState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      isSidePanelVisible: isSidePanelVisible ?? this.isSidePanelVisible,
      selectedSidebarItem: selectedSidebarItem ?? this.selectedSidebarItem,
      openedFile: clearOpenedFile ? null : (openedFile ?? this.openedFile),
      sidePanelWidth: sidePanelWidth ?? this.sidePanelWidth,
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

  void updateSidePanelWidth(double width) {
    state = state.copyWith(sidePanelWidth: width);
  }

  void loadFileContent(String filePath, String content) {
    // This method will be called to update both UI and editor state
    state = state.copyWith(openedFile: filePath);
  }
}

final uiStateProvider = StateNotifierProvider<UIStateNotifier, UIState>(
  (ref) => UIStateNotifier(),
);

// File opening service that coordinates between UI state and editor state
class FileOpeningService {
  const FileOpeningService(this._ref);
  final Ref _ref;

  Future<void> openFile(String filePath) async {
    try {
      // Update UI state first
      _ref.read(uiStateProvider.notifier).openFile(filePath);

      // Update editor state with file path immediately
      _ref.read(editorStateProvider.notifier).updateFilePath(filePath);

      // Load file content asynchronously
      final fileRepository = _ref.read(fileRepositoryProvider);
      final content = await fileRepository.readFile(filePath);

      // Update editor state with content
      _ref.read(editorStateProvider.notifier).updateContent(content);

      // If it's a Blox file, try to parse it
      if (filePath.toLowerCase().endsWith('.blox')) {
        // TODO(user): Parse Blox document when parser is available
        // final parsedDocument = await _ref.read(bloxParserProvider).parse(content);
        // _ref.read(editorStateProvider.notifier).updateParsedDocument(parsedDocument);
      }
    } catch (e) {
      // Handle error - could show snackbar or update error state
      debugPrint('Failed to open file: $e');
    }
  }

  void closeFile() {
    _ref.read(uiStateProvider.notifier).closeFile();
    _ref.read(editorStateProvider.notifier).clear();
  }
}

// Provider for file opening service
final fileOpeningServiceProvider = Provider<FileOpeningService>((ref) {
  return FileOpeningService(ref);
});
