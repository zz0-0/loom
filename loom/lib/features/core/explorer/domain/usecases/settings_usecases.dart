/// Use cases for workspace settings operations
library;

import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart';
import 'package:loom/features/core/explorer/domain/repositories/workspace_repository.dart';

/// Use case for loading settings
class LoadSettingsUseCase {
  const LoadSettingsUseCase(this.repository);

  final WorkspaceSettingsRepository repository;

  Future<WorkspaceSettings> call() async {
    return repository.loadSettings();
  }
}

/// Use case for saving settings
class SaveSettingsUseCase {
  const SaveSettingsUseCase(this.repository);

  final WorkspaceSettingsRepository repository;

  Future<void> call(WorkspaceSettings settings) async {
    return repository.saveSettings(settings);
  }
}

/// Use case for toggling file extension filter
class ToggleFileExtensionFilterUseCase {
  const ToggleFileExtensionFilterUseCase(this.repository);

  final WorkspaceSettingsRepository repository;

  Future<WorkspaceSettings> call(WorkspaceSettings currentSettings) async {
    final newSettings = currentSettings.copyWith(
      filterFileExtensions: !currentSettings.filterFileExtensions,
    );
    await repository.saveSettings(newSettings);
    return newSettings;
  }
}

/// Use case for toggling show hidden files
class ToggleShowHiddenFilesUseCase {
  const ToggleShowHiddenFilesUseCase(this.repository);

  final WorkspaceSettingsRepository repository;

  Future<WorkspaceSettings> call(WorkspaceSettings currentSettings) async {
    final newSettings = currentSettings.copyWith(
      showHiddenFiles: !currentSettings.showHiddenFiles,
    );
    await repository.saveSettings(newSettings);
    return newSettings;
  }
}

/// Use case for setting default sidebar view
class SetDefaultSidebarViewUseCase {
  const SetDefaultSidebarViewUseCase(this.repository);

  final WorkspaceSettingsRepository repository;

  Future<WorkspaceSettings> call(
    WorkspaceSettings currentSettings,
    String view,
  ) async {
    final newSettings = currentSettings.copyWith(defaultSidebarView: view);
    await repository.saveSettings(newSettings);
    return newSettings;
  }
}
