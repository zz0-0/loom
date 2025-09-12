/// Core UI state entities that are platform-agnostic
/// These represent the business logic of UI state, not the implementation
library;

/// Theme mode options
enum AppThemeMode { light, dark, system }

/// Global application UI state
class AppUIState {
  const AppUIState({
    this.isSidebarCollapsed = false,
    this.isSidePanelVisible = true,
    this.selectedSidebarItem,
    this.openedFile,
    this.themeMode = AppThemeMode.system,
    this.activeWorkspace,
  });
  final bool isSidebarCollapsed;
  final bool isSidePanelVisible;
  final String? selectedSidebarItem;
  final String? openedFile;
  final AppThemeMode themeMode;
  final String? activeWorkspace;

  AppUIState copyWith({
    bool? isSidebarCollapsed,
    bool? isSidePanelVisible,
    String? selectedSidebarItem,
    String? openedFile,
    AppThemeMode? themeMode,
    String? activeWorkspace,
  }) {
    return AppUIState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      isSidePanelVisible: isSidePanelVisible ?? this.isSidePanelVisible,
      selectedSidebarItem: selectedSidebarItem ?? this.selectedSidebarItem,
      openedFile: openedFile ?? this.openedFile,
      themeMode: themeMode ?? this.themeMode,
      activeWorkspace: activeWorkspace ?? this.activeWorkspace,
    );
  }
}

/// Navigation item configuration - platform agnostic
class NavigationItem {
  const NavigationItem({
    required this.id,
    required this.label,
    required this.iconName,
    this.sortOrder = 0,
    this.isVisible = true,
  });
  final String id;
  final String label;
  final String iconName;
  final int sortOrder;
  final bool isVisible;
}

/// Panel configuration - platform agnostic
class PanelConfig {
  const PanelConfig({
    required this.id,
    required this.title,
    this.isCollapsible = true,
    this.isResizable = true,
    this.defaultWidth,
    this.minWidth,
    this.maxWidth,
  });
  final String id;
  final String title;
  final bool isCollapsible;
  final bool isResizable;
  final double? defaultWidth;
  final double? minWidth;
  final double? maxWidth;
}
