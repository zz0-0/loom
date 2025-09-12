import 'dart:convert';
import 'dart:io';
import 'package:loom/features/core/settings/settings_core/domain/entities/settings_entities.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';

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
