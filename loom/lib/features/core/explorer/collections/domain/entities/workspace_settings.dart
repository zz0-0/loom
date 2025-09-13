/// User's global application settings
class WorkspaceSettings {
  const WorkspaceSettings({
    this.theme = 'dark',
    this.fontSize = 14,
    this.defaultSidebarView = 'filesystem', // 'filesystem' or 'collections'
    this.filterFileExtensions = true,
    this.showHiddenFiles = false,
    this.wordWrap = true,
  });

  factory WorkspaceSettings.fromJson(Map<String, dynamic> json) {
    return WorkspaceSettings(
      theme: json['theme'] as String? ?? 'dark',
      fontSize: json['fontSize'] as int? ?? 14,
      defaultSidebarView: json['defaultSidebarView'] as String? ?? 'filesystem',
      filterFileExtensions: json['filterFileExtensions'] as bool? ?? true,
      showHiddenFiles: json['showHiddenFiles'] as bool? ?? false,
      wordWrap: json['wordWrap'] as bool? ?? true,
    );
  }

  final String theme;
  final int fontSize;
  final String defaultSidebarView;
  final bool filterFileExtensions;
  final bool showHiddenFiles;
  final bool wordWrap;

  WorkspaceSettings copyWith({
    String? theme,
    int? fontSize,
    String? defaultSidebarView,
    bool? filterFileExtensions,
    bool? showHiddenFiles,
    bool? wordWrap,
  }) {
    return WorkspaceSettings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      defaultSidebarView: defaultSidebarView ?? this.defaultSidebarView,
      filterFileExtensions: filterFileExtensions ?? this.filterFileExtensions,
      showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
      wordWrap: wordWrap ?? this.wordWrap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'fontSize': fontSize,
      'defaultSidebarView': defaultSidebarView,
      'filterFileExtensions': filterFileExtensions,
      'showHiddenFiles': showHiddenFiles,
      'wordWrap': wordWrap,
    };
  }
}
