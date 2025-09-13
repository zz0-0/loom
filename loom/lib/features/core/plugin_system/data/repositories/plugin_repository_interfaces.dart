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

/// Plugin metadata model
class PluginMetadata {
  const PluginMetadata({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    this.dependencies = const [],
    this.permissions = const [],
  });

  final String id;
  final String name;
  final String version;
  final String description;
  final String author;
  final List<String> dependencies;
  final List<String> permissions;
}
