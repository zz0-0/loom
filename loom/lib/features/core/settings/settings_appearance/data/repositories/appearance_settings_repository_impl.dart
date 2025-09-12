import 'dart:convert';
import 'dart:io';
import 'package:loom/features/core/settings/settings_core/domain/entities/settings_entities.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';

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
