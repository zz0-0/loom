import 'package:loom/features/plugin_system/domain/plugin.dart';

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

/// Implementation using local storage
class LocalPluginSettingsRepository implements PluginSettingsRepository {
  // TODO(user): Implement using shared_preferences or similar
  @override
  Future<Map<String, dynamic>> loadSettings(String pluginId) async {
    // Load from local storage
    return {};
  }

  @override
  Future<void> saveSettings(
    String pluginId,
    Map<String, dynamic> settings,
  ) async {
    // Save to local storage
  }

  @override
  Future<void> clearSettings(String pluginId) async {
    // Clear from local storage
  }
}

/// Implementation using local storage
class LocalPluginMetadataRepository implements PluginMetadataRepository {
  // TODO(user): Implement using shared_preferences or similar
  @override
  Future<List<PluginMetadata>> getInstalledPlugins() async {
    return [];
  }

  @override
  Future<PluginMetadata?> getPluginMetadata(String pluginId) async {
    return null;
  }

  @override
  Future<void> savePluginMetadata(PluginMetadata metadata) async {
    // Save metadata
  }

  @override
  Future<void> removePluginMetadata(String pluginId) async {
    // Remove metadata
  }
}

/// Implementation using local storage
class LocalPluginPermissionsRepository implements PluginPermissionsRepository {
  // TODO(user): Implement using shared_preferences or similar
  @override
  Future<Set<String>> getGrantedPermissions(String pluginId) async {
    return {};
  }

  @override
  Future<void> saveGrantedPermissions(
    String pluginId,
    Set<String> permissions,
  ) async {
    // Save permissions
  }

  @override
  Future<void> clearPermissions(String pluginId) async {
    // Clear permissions
  }
}
