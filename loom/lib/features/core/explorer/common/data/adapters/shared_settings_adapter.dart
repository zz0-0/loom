import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';

/// Adapter to provide shared settings repository implementation
/// This allows shared components to use explorer's settings without direct coupling
class ExplorerSharedSettingsRepository implements SharedSettingsRepository {
  const ExplorerSharedSettingsRepository(this._repository);

  final WorkspaceSettingsRepository _repository;

  @override
  Future<String> getTheme() async {
    final settings = await _repository.loadSettings();
    return settings.theme;
  }

  @override
  Future<void> setTheme(String theme) async {
    final currentSettings = await _repository.loadSettings();
    final updatedSettings = currentSettings.copyWith(theme: theme);
    await _repository.saveSettings(updatedSettings);
  }

  @override
  Future<Map<String, dynamic>> getFontSettings() async {
    final settings = await _repository.loadSettings();
    return {
      'fontFamily': settings.fontFamily,
      'fontSize': settings.fontSize,
    };
  }

  @override
  Future<void> setFontSettings(Map<String, dynamic> fontSettings) async {
    final currentSettings = await _repository.loadSettings();
    final updatedSettings = currentSettings.copyWith(
      fontFamily: fontSettings['fontFamily'] as String?,
      fontSize: fontSettings['fontSize'] as int?,
    );
    await _repository.saveSettings(updatedSettings);
  }
}
