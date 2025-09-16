import 'package:loom/features/core/explorer/index.dart';

/// Data model for WorkspaceSettings with JSON serialization
class WorkspaceSettingsModel extends WorkspaceSettings {
  const WorkspaceSettingsModel({
    super.theme = 'dark',
    super.fontFamily = 'Inter',
    super.fontSize = 14,
    super.defaultSidebarView = 'filesystem',
    super.filterFileExtensions = true,
    super.showHiddenFiles = false,
    super.wordWrap = true,
  });

  factory WorkspaceSettingsModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceSettingsModel(
      theme: _validateTheme(json['theme'] as String? ?? 'dark'),
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      fontSize: _validateFontSize(json['fontSize'] as int? ?? 14),
      defaultSidebarView: _validateSidebarView(
        json['defaultSidebarView'] as String? ?? 'filesystem',
      ),
      filterFileExtensions: json['filterFileExtensions'] as bool? ?? true,
      showHiddenFiles: json['showHiddenFiles'] as bool? ?? false,
      wordWrap: json['wordWrap'] as bool? ?? true,
    );
  }

  static String _validateTheme(String theme) {
    const validThemes = ['light', 'dark', 'system'];
    return validThemes.contains(theme) ? theme : 'dark';
  }

  static int _validateFontSize(int fontSize) {
    return fontSize.clamp(8, 72); // Reasonable font size range
  }

  static String _validateSidebarView(String view) {
    const validViews = ['filesystem', 'collections'];
    return validViews.contains(view) ? view : 'filesystem';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'defaultSidebarView': defaultSidebarView,
      'filterFileExtensions': filterFileExtensions,
      'showHiddenFiles': showHiddenFiles,
      'wordWrap': wordWrap,
    };
  }

  WorkspaceSettings toDomain() => this;
}
