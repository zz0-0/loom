import 'package:loom/features/settings/domain/entities/settings_entities.dart';

/// Repository for managing appearance settings
abstract class AppearanceSettingsRepository {
  Future<AppearanceSettings> loadSettings();
  Future<void> saveSettings(AppearanceSettings settings);
}

/// Repository for managing interface settings
abstract class InterfaceSettingsRepository {
  Future<InterfaceSettings> loadSettings();
  Future<void> saveSettings(InterfaceSettings settings);
}

/// Repository for managing general settings
abstract class GeneralSettingsRepository {
  Future<GeneralSettings> loadSettings();
  Future<void> saveSettings(GeneralSettings settings);
}

/// Repository for application information
abstract class AppInfoRepository {
  Future<AppInfo> getAppInfo();
}
