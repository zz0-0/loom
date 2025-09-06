import 'package:loom/features/settings/domain/entities/settings_entities.dart';
import 'package:loom/features/settings/domain/repositories/settings_repositories.dart';

/// Use case for loading appearance settings
class LoadAppearanceSettingsUseCaseImpl
    implements LoadAppearanceSettingsUseCase {
  const LoadAppearanceSettingsUseCaseImpl(this.repository);

  final AppearanceSettingsRepository repository;

  @override
  Future<AppearanceSettings> execute() {
    return repository.loadSettings();
  }
}

/// Use case for saving appearance settings
class SaveAppearanceSettingsUseCaseImpl
    implements SaveAppearanceSettingsUseCase {
  const SaveAppearanceSettingsUseCaseImpl(this.repository);

  final AppearanceSettingsRepository repository;

  @override
  Future<void> execute(AppearanceSettings settings) {
    return repository.saveSettings(settings);
  }
}

/// Use case for loading interface settings
class LoadInterfaceSettingsUseCaseImpl implements LoadInterfaceSettingsUseCase {
  const LoadInterfaceSettingsUseCaseImpl(this.repository);

  final InterfaceSettingsRepository repository;

  @override
  Future<InterfaceSettings> execute() {
    return repository.loadSettings();
  }
}

/// Use case for saving interface settings
class SaveInterfaceSettingsUseCaseImpl implements SaveInterfaceSettingsUseCase {
  const SaveInterfaceSettingsUseCaseImpl(this.repository);

  final InterfaceSettingsRepository repository;

  @override
  Future<void> execute(InterfaceSettings settings) {
    return repository.saveSettings(settings);
  }
}

/// Use case for loading general settings
class LoadGeneralSettingsUseCaseImpl implements LoadGeneralSettingsUseCase {
  const LoadGeneralSettingsUseCaseImpl(this.repository);

  final GeneralSettingsRepository repository;

  @override
  Future<GeneralSettings> execute() {
    return repository.loadSettings();
  }
}

/// Use case for saving general settings
class SaveGeneralSettingsUseCaseImpl implements SaveGeneralSettingsUseCase {
  const SaveGeneralSettingsUseCaseImpl(this.repository);

  final GeneralSettingsRepository repository;

  @override
  Future<void> execute(GeneralSettings settings) {
    return repository.saveSettings(settings);
  }
}

/// Use case for getting application information
class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  const GetAppInfoUseCaseImpl(this.repository);

  final AppInfoRepository repository;

  @override
  Future<AppInfo> execute() {
    return repository.getAppInfo();
  }
}

/// Abstract classes for interface
abstract class LoadAppearanceSettingsUseCase {
  Future<AppearanceSettings> execute();
}

abstract class SaveAppearanceSettingsUseCase {
  Future<void> execute(AppearanceSettings settings);
}

abstract class LoadInterfaceSettingsUseCase {
  Future<InterfaceSettings> execute();
}

abstract class SaveInterfaceSettingsUseCase {
  Future<void> execute(InterfaceSettings settings);
}

abstract class LoadGeneralSettingsUseCase {
  Future<GeneralSettings> execute();
}

abstract class SaveGeneralSettingsUseCase {
  Future<void> execute(GeneralSettings settings);
}

abstract class GetAppInfoUseCase {
  Future<AppInfo> execute();
}
