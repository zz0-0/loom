import 'package:loom/features/core/settings/index.dart';

/// Implementation of appearance settings repository
class AppearanceSettingsRepositoryImpl implements AppearanceSettingsRepository {
  AppearanceSettingsRepositoryImpl(
    this._fileService,
    this._serializationService,
  );

  final SettingsFileService _fileService;
  final SettingsSerializationService _serializationService;

  static const String settingsFileName = 'appearance_settings.json';

  @override
  Future<AppearanceSettings> loadSettings() async {
    final jsonData = _fileService.readJsonFile(settingsFileName);
    return _serializationService.deserializeAppearanceSettings(jsonData);
  }

  @override
  Future<void> saveSettings(AppearanceSettings settings) async {
    final jsonData =
        _serializationService.serializeAppearanceSettings(settings);
    _fileService.writeJsonFile(settingsFileName, jsonData);
  }
}
