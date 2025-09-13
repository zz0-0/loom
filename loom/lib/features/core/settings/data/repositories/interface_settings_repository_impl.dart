import 'package:loom/features/core/settings/index.dart';

/// Implementation of interface settings repository
class InterfaceSettingsRepositoryImpl implements InterfaceSettingsRepository {
  InterfaceSettingsRepositoryImpl(
    this._fileService,
    this._serializationService,
  );

  final SettingsFileService _fileService;
  final SettingsSerializationService _serializationService;

  static const String settingsFileName = 'interface_settings.json';

  @override
  Future<InterfaceSettings> loadSettings() async {
    final jsonData = _fileService.readJsonFile(settingsFileName);
    return _serializationService.deserializeInterfaceSettings(jsonData);
  }

  @override
  Future<void> saveSettings(InterfaceSettings settings) async {
    final jsonData = _serializationService.serializeInterfaceSettings(settings);
    _fileService.writeJsonFile(settingsFileName, jsonData);
  }
}
