import 'package:loom/features/core/settings/index.dart';

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

/// Abstract classes for interface
abstract class LoadInterfaceSettingsUseCase {
  Future<InterfaceSettings> execute();
  bool canExecute() => true;
}

abstract class SaveInterfaceSettingsUseCase {
  Future<void> execute(InterfaceSettings settings);
  bool canExecute(InterfaceSettings settings) => true;
}
