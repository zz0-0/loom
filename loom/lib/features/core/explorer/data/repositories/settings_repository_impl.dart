/// Implementation of WorkspaceSettingsRepository
library;

import 'dart:convert';
import 'dart:io';

import 'package:loom/features/core/explorer/index.dart';
import 'package:path/path.dart' as path;

/// Implementation of WorkspaceSettingsRepository
class WorkspaceSettingsRepositoryImpl implements WorkspaceSettingsRepository {
  static const String settingsFileName = 'settings.json';

  String _getAppDataDirectory() {
    // For now, use home directory - in production, use proper app data directory
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '.';
    return path.join(home, '.loom');
  }

  @override
  Future<WorkspaceSettings> loadSettings() async {
    final appDataDir = _getAppDataDirectory();
    final settingsFile = File(path.join(appDataDir, settingsFileName));

    if (!settingsFile.existsSync()) {
      return const WorkspaceSettings();
    }

    final jsonString = await settingsFile.readAsString();
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final model = WorkspaceSettingsModel.fromJson(jsonData);
    return model.toDomain();
  }

  @override
  Future<void> saveSettings(WorkspaceSettings settings) async {
    final appDataDir = _getAppDataDirectory();
    final appDataDirectory = Directory(appDataDir);

    if (!appDataDirectory.existsSync()) {
      await appDataDirectory.create(recursive: true);
    }

    final settingsFile = File(path.join(appDataDir, settingsFileName));
    final model = WorkspaceSettingsModel(
      theme: settings.theme,
      fontSize: settings.fontSize,
      defaultSidebarView: settings.defaultSidebarView,
      filterFileExtensions: settings.filterFileExtensions,
      showHiddenFiles: settings.showHiddenFiles,
      wordWrap: settings.wordWrap,
    );

    final jsonString =
        const JsonEncoder.withIndent('  ').convert(model.toJson());
    await settingsFile.writeAsString(jsonString);
  }
}
