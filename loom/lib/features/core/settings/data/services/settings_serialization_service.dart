import 'package:loom/features/core/settings/index.dart';

/// Service for handling settings serialization/deserialization
class SettingsSerializationService {
  const SettingsSerializationService();

  /// Deserialize appearance settings from JSON
  AppearanceSettings deserializeAppearanceSettings(
      Map<String, dynamic>? jsonData,) {
    if (jsonData == null) {
      return const AppearanceSettings();
    }

    return AppearanceSettings(
      theme: jsonData['theme'] as String? ?? 'system',
      fontSize: (jsonData['fontSize'] as num?)?.toDouble() ?? 14.0,
      compactMode: jsonData['compactMode'] as bool? ?? false,
    );
  }

  /// Serialize appearance settings to JSON
  Map<String, dynamic> serializeAppearanceSettings(
      AppearanceSettings settings,) {
    return {
      'theme': settings.theme,
      'fontSize': settings.fontSize,
      'compactMode': settings.compactMode,
    };
  }

  /// Deserialize general settings from JSON
  GeneralSettings deserializeGeneralSettings(Map<String, dynamic>? jsonData) {
    if (jsonData == null) {
      return const GeneralSettings();
    }

    return GeneralSettings(
      autoSave: jsonData['autoSave'] as bool? ?? true,
      confirmOnExit: jsonData['confirmOnExit'] as bool? ?? true,
      language: jsonData['language'] as String? ?? 'en',
    );
  }

  /// Serialize general settings to JSON
  Map<String, dynamic> serializeGeneralSettings(GeneralSettings settings) {
    return {
      'autoSave': settings.autoSave,
      'confirmOnExit': settings.confirmOnExit,
      'language': settings.language,
    };
  }

  /// Deserialize interface settings from JSON
  InterfaceSettings deserializeInterfaceSettings(
      Map<String, dynamic>? jsonData,) {
    if (jsonData == null) {
      return const InterfaceSettings();
    }

    return InterfaceSettings(
      showSidebar: jsonData['showSidebar'] as bool? ?? true,
      showBottomBar: jsonData['showBottomBar'] as bool? ?? true,
      sidebarPosition: jsonData['sidebarPosition'] as String? ?? 'left',
      closeButtonPosition: jsonData['closeButtonPosition'] as String? ?? 'auto',
    );
  }

  /// Serialize interface settings to JSON
  Map<String, dynamic> serializeInterfaceSettings(InterfaceSettings settings) {
    return {
      'showSidebar': settings.showSidebar,
      'showBottomBar': settings.showBottomBar,
      'sidebarPosition': settings.sidebarPosition,
      'closeButtonPosition': settings.closeButtonPosition,
    };
  }
}
