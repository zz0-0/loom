import 'package:loom/features/core/settings/index.dart';

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

/// Abstract classes for interface
abstract class LoadGeneralSettingsUseCase {
  Future<GeneralSettings> execute();
  bool canExecute() => true;
}

abstract class SaveGeneralSettingsUseCase {
  Future<void> execute(GeneralSettings settings);
  bool canExecute(GeneralSettings settings) => true;
}
