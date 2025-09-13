import 'package:loom/features/core/settings/index.dart';

/// Implementation of general settings repository
class GeneralSettingsRepositoryImpl implements GeneralSettingsRepository {
  GeneralSettingsRepositoryImpl(
    this._fileService,
    this._serializationService,
  );

  final SettingsFileService _fileService;
  final SettingsSerializationService _serializationService;

  static const String settingsFileName = 'general_settings.json';

  @override
  Future<GeneralSettings> loadSettings() async {
    final jsonData = _fileService.readJsonFile(settingsFileName);
    return _serializationService.deserializeGeneralSettings(jsonData);
  }

  @override
  Future<void> saveSettings(GeneralSettings settings) async {
    final jsonData = _serializationService.serializeGeneralSettings(settings);
    _fileService.writeJsonFile(settingsFileName, jsonData);
  }
}
