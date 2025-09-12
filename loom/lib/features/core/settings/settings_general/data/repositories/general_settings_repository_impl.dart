import 'dart:convert';
import 'dart:io';
import 'package:loom/features/core/settings/settings_core/domain/entities/settings_entities.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';

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
