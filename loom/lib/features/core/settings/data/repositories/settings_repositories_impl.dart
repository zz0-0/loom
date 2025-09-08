import 'dart:convert';
import 'dart:io';
import 'package:loom/features/core/settings/domain/entities/settings_entities.dart';
import 'package:loom/features/core/settings/domain/repositories/settings_repositories.dart';

/// Implementation of appearance settings repository
class AppearanceSettingsRepositoryImpl implements AppearanceSettingsRepository {
  static const String settingsFileName = 'appearance_settings.json';

  @override
  Future<AppearanceSettings> loadSettings() async {
    try {
      final file = File(settingsFileName);
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        return const AppearanceSettings();
      }

      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return AppearanceSettings(
        theme: jsonData['theme'] as String? ?? 'system',
        fontSize: (jsonData['fontSize'] as num?)?.toDouble() ?? 14.0,
        compactMode: jsonData['compactMode'] as bool? ?? false,
      );
    } catch (e) {
      return const AppearanceSettings();
    }
  }

  @override
  Future<void> saveSettings(AppearanceSettings settings) async {
    final file = File(settingsFileName);
    final jsonData = {
      'theme': settings.theme,
      'fontSize': settings.fontSize,
      'compactMode': settings.compactMode,
    };
    await file.writeAsString(json.encode(jsonData));
  }
}

/// Implementation of interface settings repository
class InterfaceSettingsRepositoryImpl implements InterfaceSettingsRepository {
  static const String settingsFileName = 'interface_settings.json';

  @override
  Future<InterfaceSettings> loadSettings() async {
    try {
      final file = File(settingsFileName);
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        return const InterfaceSettings();
      }

      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return InterfaceSettings(
        showSidebar: jsonData['showSidebar'] as bool? ?? true,
        showBottomBar: jsonData['showBottomBar'] as bool? ?? true,
        sidebarPosition: jsonData['sidebarPosition'] as String? ?? 'left',
        closeButtonPosition:
            jsonData['closeButtonPosition'] as String? ?? 'auto',
      );
    } catch (e) {
      return const InterfaceSettings();
    }
  }

  @override
  Future<void> saveSettings(InterfaceSettings settings) async {
    final file = File(settingsFileName);
    final jsonData = {
      'showSidebar': settings.showSidebar,
      'showBottomBar': settings.showBottomBar,
      'sidebarPosition': settings.sidebarPosition,
      'closeButtonPosition': settings.closeButtonPosition,
    };
    await file.writeAsString(json.encode(jsonData));
  }
}

/// Implementation of general settings repository
class GeneralSettingsRepositoryImpl implements GeneralSettingsRepository {
  static const String settingsFileName = 'general_settings.json';

  @override
  Future<GeneralSettings> loadSettings() async {
    try {
      final file = File(settingsFileName);
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        return const GeneralSettings();
      }

      final jsonString = await file.readAsString();
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return GeneralSettings(
        autoSave: jsonData['autoSave'] as bool? ?? true,
        confirmOnExit: jsonData['confirmOnExit'] as bool? ?? true,
        language: jsonData['language'] as String? ?? 'en',
      );
    } catch (e) {
      return const GeneralSettings();
    }
  }

  @override
  Future<void> saveSettings(GeneralSettings settings) async {
    final file = File(settingsFileName);
    final jsonData = {
      'autoSave': settings.autoSave,
      'confirmOnExit': settings.confirmOnExit,
      'language': settings.language,
    };
    await file.writeAsString(json.encode(jsonData));
  }
}

/// Implementation of app info repository
class AppInfoRepositoryImpl implements AppInfoRepository {
  @override
  Future<AppInfo> getAppInfo() async {
    return const AppInfo(
      name: 'Loom',
      version: '1.0.0',
      buildNumber: '1',
      description: 'A knowledge base application',
    );
  }
}
