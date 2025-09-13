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

/// Abstract classes for interface
abstract class LoadAppearanceSettingsUseCase {
  Future<AppearanceSettings> execute();
  bool canExecute() => true;
}

abstract class SaveAppearanceSettingsUseCase {
  Future<void> execute(AppearanceSettings settings);
  bool canExecute(AppearanceSettings settings) => true;
}
