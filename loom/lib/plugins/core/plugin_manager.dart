import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';
import 'package:loom/plugins/communication/plugin_ipc_manager.dart';
import 'package:loom/plugins/isolation/plugin_isolate_manager.dart';
import 'package:loom/plugins/registry/plugin_registry.dart';

/// Main entry point for the plugin system v2.0
/// Coordinates between registry, isolation, and communication components
class PluginManager {
  PluginManager._();
  late final PluginIsolateManager _isolateManager;
  late final PluginIPCManager _ipcManager;
  late final PluginRegistry _registry;

  bool _initialized = false;

  /// Get the singleton instance
  static PluginManager? _instance;

  static PluginManager get instance {
    _instance ??= PluginManager._();
    return _instance!;
  }

  /// Initialize the plugin system
  Future<void> initialize({
    String pluginsDirectory = 'plugins',
    bool autoLoadPlugins = true,
  }) async {
    if (_initialized) {
      return;
    }

    // Initialize components
    _isolateManager = PluginIsolateManager();
    _ipcManager = PluginIPCManager();
    _registry = PluginRegistry(
      isolateManager: _isolateManager,
      ipcManager: _ipcManager,
      pluginsDirectory: pluginsDirectory,
    );

    // Initialize registry (this will discover plugins)
    await _registry.initialize();

    if (autoLoadPlugins) {
      await _loadAllPlugins();
    }

    _initialized = true;
    print('Plugin system v2.0 initialized');
  }

  /// Load all discovered plugins
  Future<void> _loadAllPlugins() async {
    final installedPlugins = _registry.getInstalledPlugins();

    for (final manifest in installedPlugins) {
      try {
        await _registry.loadPlugin(manifest.id);
        print('Auto-loaded plugin: ${manifest.name}');
      } catch (e) {
        print('Failed to auto-load plugin ${manifest.name}: $e');
      }
    }
  }

  /// Install a plugin from a package
  Future<bool> installPlugin(String pluginPackagePath) async {
    _ensureInitialized();
    return _registry.installPlugin(pluginPackagePath);
  }

  /// Uninstall a plugin
  Future<bool> uninstallPlugin(String pluginId) async {
    _ensureInitialized();
    return _registry.uninstallPlugin(pluginId);
  }

  /// Load and activate a plugin
  Future<bool> loadPlugin(String pluginId) async {
    _ensureInitialized();
    return _registry.loadPlugin(pluginId);
  }

  /// Unload a plugin
  Future<bool> unloadPlugin(String pluginId) async {
    _ensureInitialized();
    return _registry.unloadPlugin(pluginId);
  }

  /// Enable a plugin
  Future<bool> enablePlugin(String pluginId) async {
    _ensureInitialized();
    return _registry.enablePlugin(pluginId);
  }

  /// Disable a plugin
  Future<bool> disablePlugin(String pluginId) async {
    _ensureInitialized();
    return _registry.disablePlugin(pluginId);
  }

  /// Execute a command on a plugin
  Future<CommandResult> executeCommand(
    String pluginId,
    String commandId,
    Map<String, dynamic> args,
  ) async {
    _ensureInitialized();
    return _registry.executeCommand(pluginId, commandId, args);
  }

  /// Execute a file operation on a plugin
  Future<FileOperationResult> executeFileOperation(
    String pluginId,
    String operation,
    String filePath,
    dynamic data,
  ) async {
    _ensureInitialized();
    return _registry.executeFileOperation(
      pluginId,
      operation,
      filePath,
      data,
    );
  }

  /// Send a message to a plugin
  Future<dynamic> sendMessage(String pluginId, IPCMessage message) async {
    _ensureInitialized();
    return _ipcManager.sendMessage(pluginId, message);
  }

  /// Broadcast a message to all active plugins
  Future<void> broadcastMessage(IPCMessage message) async {
    _ensureInitialized();
    await _ipcManager.broadcastMessage(message);
  }

  /// Get all installed plugins
  List<PluginManifest> getInstalledPlugins() {
    _ensureInitialized();
    return _registry.getInstalledPlugins();
  }

  /// Get all active plugins
  List<PluginManifest> getActivePlugins() {
    _ensureInitialized();
    return _registry.getActivePlugins();
  }

  /// Get plugin manifest by ID
  PluginManifest? getPluginManifest(String pluginId) {
    _ensureInitialized();
    return _registry.getPluginManifest(pluginId);
  }

  /// Get plugin state
  PluginState getPluginState(String pluginId) {
    _ensureInitialized();
    return _registry.getPluginState(pluginId);
  }

  /// Get plugin runtime info
  PluginRuntimeInfo? getPluginRuntimeInfo(String pluginId) {
    _ensureInitialized();
    return _registry.getPluginRuntimeInfo(pluginId);
  }

  /// Get plugins by capability
  List<PluginManifest> getPluginsByCapability(String capability) {
    _ensureInitialized();
    return _registry.getPluginsByCapability(capability);
  }

  /// Get plugins that support a file extension
  List<PluginManifest> getPluginsForFileExtension(String extension) {
    _ensureInitialized();
    return _registry.getPluginsForFileExtension(extension);
  }

  /// Handle lifecycle events
  Future<void> handleLifecycleEvent(String eventType, dynamic data) async {
    _ensureInitialized();

    final message = IPCMessage.lifecycleEvent(eventType, data);
    await broadcastMessage(message);
  }

  /// Handle UI events
  Future<void> handleUIEvent(String eventType, dynamic data) async {
    _ensureInitialized();

    final message = IPCMessage.uiEvent(eventType, data);
    await broadcastMessage(message);
  }

  /// Handle file operations
  Future<List<FileOperationResult>> handleFileOperation(
    String operation,
    String filePath,
    dynamic data,
  ) async {
    _ensureInitialized();

    final results = <FileOperationResult>[];
    final plugins = getPluginsForFileExtension(_getFileExtension(filePath));

    for (final plugin in plugins) {
      if (getPluginState(plugin.id) == PluginState.active) {
        try {
          final result = await executeFileOperation(
            plugin.id,
            operation,
            filePath,
            data,
          );
          results.add(result);
        } catch (e) {
          results
              .add(FileOperationResult.error('Plugin ${plugin.id} failed: $e'));
        }
      }
    }

    return results;
  }

  /// Register a hook handler
  Future<void> registerHook(String hookName, Function handler) async {
    _ensureInitialized();

    // Find plugins that provide this hook
    final plugins = getPluginsByCapability(hookName);

    for (final plugin in plugins) {
      if (getPluginState(plugin.id) == PluginState.active) {
        // TODO: Implement hook registration with plugins
        print('Registered hook $hookName with plugin ${plugin.id}');
      }
    }
  }

  /// Shutdown the plugin system
  Future<void> shutdown() async {
    if (!_initialized) {
      return;
    }

    print('Shutting down plugin system...');

    // Shutdown registry (this will unload all plugins)
    await _registry.shutdown();

    _initialized = false;
    print('Plugin system shutdown complete');
  }

  /// Ensure the plugin system is initialized
  void _ensureInitialized() {
    if (!_initialized) {
      throw PluginManagerException(
        'Plugin system not initialized. Call initialize() first.',
      );
    }
  }

  /// Extract file extension from path
  String _getFileExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1) return '';
    return filePath.substring(lastDot + 1).toLowerCase();
  }
}

/// Exception thrown by the plugin manager
class PluginManagerException implements Exception {
  PluginManagerException(this.message);
  final String message;

  @override
  String toString() => 'PluginManagerException: $message';
}

/// Extension methods for easier plugin management
extension PluginManagerExtensions on PluginManager {
  /// Check if a plugin is installed
  bool isPluginInstalled(String pluginId) {
    return getPluginManifest(pluginId) != null;
  }

  /// Check if a plugin is active
  bool isPluginActive(String pluginId) {
    return getPluginState(pluginId) == PluginState.active;
  }

  /// Get active plugins count
  int get activePluginsCount => getActivePlugins().length;

  /// Get installed plugins count
  int get installedPluginsCount => getInstalledPlugins().length;
}
