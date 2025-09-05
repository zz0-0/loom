/// Domain entities for the settings feature
library;

/// Settings categories available in the application
enum SettingsCategory {
  appearance,
  interface,
  general,
  about,
}

/// Appearance settings entity
class AppearanceSettings {
  const AppearanceSettings({
    this.theme = 'system',
    this.fontSize = 14.0,
    this.compactMode = false,
  });

  final String theme;
  final double fontSize;
  final bool compactMode;

  AppearanceSettings copyWith({
    String? theme,
    double? fontSize,
    bool? compactMode,
  }) {
    return AppearanceSettings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      compactMode: compactMode ?? this.compactMode,
    );
  }
}

/// Interface settings entity
class InterfaceSettings {
  const InterfaceSettings({
    this.showSidebar = true,
    this.showBottomBar = true,
    this.sidebarPosition = 'left',
    this.closeButtonPosition = 'auto',
  });

  final bool showSidebar;
  final bool showBottomBar;
  final String sidebarPosition;
  final String closeButtonPosition;

  InterfaceSettings copyWith({
    bool? showSidebar,
    bool? showBottomBar,
    String? sidebarPosition,
    String? closeButtonPosition,
  }) {
    return InterfaceSettings(
      showSidebar: showSidebar ?? this.showSidebar,
      showBottomBar: showBottomBar ?? this.showBottomBar,
      sidebarPosition: sidebarPosition ?? this.sidebarPosition,
      closeButtonPosition: closeButtonPosition ?? this.closeButtonPosition,
    );
  }
}

/// General settings entity
class GeneralSettings {
  const GeneralSettings({
    this.autoSave = true,
    this.confirmOnExit = true,
    this.language = 'en',
  });

  final bool autoSave;
  final bool confirmOnExit;
  final String language;

  GeneralSettings copyWith({
    bool? autoSave,
    bool? confirmOnExit,
    String? language,
  }) {
    return GeneralSettings(
      autoSave: autoSave ?? this.autoSave,
      confirmOnExit: confirmOnExit ?? this.confirmOnExit,
      language: language ?? this.language,
    );
  }
}

/// Application information entity
class AppInfo {
  const AppInfo({
    required this.version,
    required this.buildNumber,
    required this.name,
    this.description,
  });

  final String version;
  final String buildNumber;
  final String name;
  final String? description;
}
