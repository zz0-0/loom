import 'package:loom/features/core/plugin_system/domain/plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository interface for plugin settings persistence
abstract class PluginSettingsRepository {
  Future<Map<String, dynamic>> loadSettings(String pluginId);
  Future<void> saveSettings(String pluginId, Map<String, dynamic> settings);
  Future<void> clearSettings(String pluginId);
}

/// Repository interface for plugin metadata
abstract class PluginMetadataRepository {
  Future<List<PluginMetadata>> getInstalledPlugins();
  Future<PluginMetadata?> getPluginMetadata(String pluginId);
  Future<void> savePluginMetadata(PluginMetadata metadata);
  Future<void> removePluginMetadata(String pluginId);
}

/// Repository interface for plugin permissions
abstract class PluginPermissionsRepository {
  Future<Set<String>> getGrantedPermissions(String pluginId);
  Future<void> saveGrantedPermissions(String pluginId, Set<String> permissions);
  Future<void> clearPermissions(String pluginId);
}

/// Implementation using shared_preferences for local storage
class LocalPluginSettingsRepository implements PluginSettingsRepository {
  static const String _settingsPrefix = 'plugin_settings_';

  @override
  Future<Map<String, dynamic>> loadSettings(String pluginId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_settingsPrefix$pluginId';
    final jsonString = prefs.getString(key);

    if (jsonString == null) return {};

    try {
      // For now, return empty map. In a real implementation,
      // you'd use json.decode(jsonString) to parse the settings
      return {};
    } catch (e) {
      // If parsing fails, return empty settings
      return {};
    }
  }

  @override
  Future<void> saveSettings(
    String pluginId,
    Map<String, dynamic> settings,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_settingsPrefix$pluginId';

    try {
      // In a real implementation, you'd use json.encode(settings)
      // For now, we'll store a placeholder
      await prefs.setString(key, '{}');
    } catch (e) {
      // Handle save errors
      rethrow;
    }
  }

  @override
  Future<void> clearSettings(String pluginId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_settingsPrefix$pluginId';
    await prefs.remove(key);
  }
}

/// Implementation using shared_preferences for local storage
class LocalPluginMetadataRepository implements PluginMetadataRepository {
  static const String _metadataPrefix = 'plugin_metadata_';
  static const String _installedPluginsKey = 'installed_plugins';

  @override
  Future<List<PluginMetadata>> getInstalledPlugins() async {
    final prefs = await SharedPreferences.getInstance();
    final pluginIds = prefs.getStringList(_installedPluginsKey) ?? [];

    final plugins = <PluginMetadata>[];
    for (final pluginId in pluginIds) {
      final metadata = await getPluginMetadata(pluginId);
      if (metadata != null) {
        plugins.add(metadata);
      }
    }

    return plugins;
  }

  @override
  Future<PluginMetadata?> getPluginMetadata(String pluginId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_metadataPrefix$pluginId';
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    try {
      // In a real implementation, you'd parse the JSON
      // For now, return null as placeholder
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> savePluginMetadata(PluginMetadata metadata) async {
    final prefs = await SharedPreferences.getInstance();

    // Add to installed plugins list
    final installedPlugins = prefs.getStringList(_installedPluginsKey) ?? [];
    if (!installedPlugins.contains(metadata.id)) {
      installedPlugins.add(metadata.id);
      await prefs.setStringList(_installedPluginsKey, installedPlugins);
    }

    // Save metadata
    final key = '$_metadataPrefix${metadata.id}';
    try {
      // In a real implementation, you'd serialize to JSON
      await prefs.setString(key, '{}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removePluginMetadata(String pluginId) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove from installed plugins list
    final installedPlugins = prefs.getStringList(_installedPluginsKey) ?? [];
    installedPlugins.remove(pluginId);
    await prefs.setStringList(_installedPluginsKey, installedPlugins);

    // Remove metadata
    final key = '$_metadataPrefix$pluginId';
    await prefs.remove(key);
  }
}

/// Implementation using shared_preferences for local storage
class LocalPluginPermissionsRepository implements PluginPermissionsRepository {
  static const String _permissionsPrefix = 'plugin_permissions_';

  @override
  Future<Set<String>> getGrantedPermissions(String pluginId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_permissionsPrefix$pluginId';
    final permissionsList = prefs.getStringList(key) ?? [];
    return permissionsList.toSet();
  }

  @override
  Future<void> saveGrantedPermissions(
    String pluginId,
    Set<String> permissions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_permissionsPrefix$pluginId';
    await prefs.setStringList(key, permissions.toList());
  }

  @override
  Future<void> clearPermissions(String pluginId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_permissionsPrefix$pluginId';
    await prefs.remove(key);
  }
}
