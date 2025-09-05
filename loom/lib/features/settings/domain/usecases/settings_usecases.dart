import 'package:loom/features/settings/domain/entities/settings_entities.dart';

/// Use case for loading appearance settings
abstract class LoadAppearanceSettingsUseCase {
  Future<AppearanceSettings> execute();
}

/// Use case for saving appearance settings
abstract class SaveAppearanceSettingsUseCase {
  Future<void> execute(AppearanceSettings settings);
}

/// Use case for loading interface settings
abstract class LoadInterfaceSettingsUseCase {
  Future<InterfaceSettings> execute();
}

/// Use case for saving interface settings
abstract class SaveInterfaceSettingsUseCase {
  Future<void> execute(InterfaceSettings settings);
}

/// Use case for loading general settings
abstract class LoadGeneralSettingsUseCase {
  Future<GeneralSettings> execute();
}

/// Use case for saving general settings
abstract class SaveGeneralSettingsUseCase {
  Future<void> execute(GeneralSettings settings);
}

/// Use case for getting application information
abstract class GetAppInfoUseCase {
  Future<AppInfo> execute();
}
