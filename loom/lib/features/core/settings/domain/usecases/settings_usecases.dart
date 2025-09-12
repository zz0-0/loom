import 'package:loom/features/core/settings/index.dart';

/// Use case for loading appearance settings
class LoadAppearanceSettingsUseCaseImpl
    implements LoadAppearanceSettingsUseCase {
  const LoadAppearanceSettingsUseCaseImpl(this.repository);

  final AppearanceSettingsRepository repository;

  @override
  Future<AppearanceSettings> execute() {
    return repository.loadSettings();
  }

  @override
  bool canExecute() => true;
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

  @override
  bool canExecute(AppearanceSettings settings) => true;
}

/// Use case for loading interface settings
class LoadInterfaceSettingsUseCaseImpl implements LoadInterfaceSettingsUseCase {
  const LoadInterfaceSettingsUseCaseImpl(this.repository);

  final InterfaceSettingsRepository repository;

  @override
  Future<InterfaceSettings> execute() {
    return repository.loadSettings();
  }

  @override
  bool canExecute() => true;
}

/// Use case for saving interface settings
class SaveInterfaceSettingsUseCaseImpl implements SaveInterfaceSettingsUseCase {
  const SaveInterfaceSettingsUseCaseImpl(this.repository);

  final InterfaceSettingsRepository repository;

  @override
  Future<void> execute(InterfaceSettings settings) {
    return repository.saveSettings(settings);
  }

  @override
  bool canExecute(InterfaceSettings settings) => true;
}

/// Use case for loading general settings
class LoadGeneralSettingsUseCaseImpl implements LoadGeneralSettingsUseCase {
  const LoadGeneralSettingsUseCaseImpl(this.repository);

  final GeneralSettingsRepository repository;

  @override
  Future<GeneralSettings> execute() {
    return repository.loadSettings();
  }

  @override
  bool canExecute() => true;
}

/// Use case for saving general settings
class SaveGeneralSettingsUseCaseImpl implements SaveGeneralSettingsUseCase {
  const SaveGeneralSettingsUseCaseImpl(this.repository);

  final GeneralSettingsRepository repository;

  @override
  Future<void> execute(GeneralSettings settings) {
    return repository.saveSettings(settings);
  }

  @override
  bool canExecute(GeneralSettings settings) => true;
}

/// Use case for getting application information
class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  const GetAppInfoUseCaseImpl(this.repository);

  final AppInfoRepository repository;

  @override
  Future<AppInfo> execute() {
    return repository.getAppInfo();
  }

  @override
  bool canExecute() => true;
}

/// Abstract classes for interface
abstract class LoadAppearanceSettingsUseCase {
  Future<AppearanceSettings> execute();
  bool canExecute() => true;
}

abstract class SaveAppearanceSettingsUseCase {
  Future<void> execute(AppearanceSettings settings);
  bool canExecute(AppearanceSettings settings) => true;
}

abstract class LoadInterfaceSettingsUseCase {
  Future<InterfaceSettings> execute();
  bool canExecute() => true;
}

abstract class SaveInterfaceSettingsUseCase {
  Future<void> execute(InterfaceSettings settings);
  bool canExecute(InterfaceSettings settings) => true;
}

abstract class LoadGeneralSettingsUseCase {
  Future<GeneralSettings> execute();
  bool canExecute() => true;
}

abstract class SaveGeneralSettingsUseCase {
  Future<void> execute(GeneralSettings settings);
  bool canExecute(GeneralSettings settings) => true;
}

abstract class GetAppInfoUseCase {
  Future<AppInfo> execute();
  bool canExecute() => true;
}
