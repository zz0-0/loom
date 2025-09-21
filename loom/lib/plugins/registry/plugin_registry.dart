import 'dart:developer';
import 'dart:io';

import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';
import 'package:loom/plugins/communication/plugin_ipc_manager.dart';
import 'package:loom/plugins/isolation/plugin_isolate_manager.dart';

/// Manages the discovery, loading, and lifecycle of plugins
class PluginRegistry {
  PluginRegistry({
    required PluginIsolateManager isolateManager,
    required PluginIPCManager ipcManager,
    required String pluginsDirectory,
  })  : _isolateManager = isolateManager,
        _ipcManager = ipcManager,
        _pluginsDirectory = pluginsDirectory;
  final PluginIsolateManager _isolateManager;
  final PluginIPCManager _ipcManager;
  final String _pluginsDirectory;

  final Map<String, PluginManifest> _loadedManifests = {};
  final Map<String, PluginRuntimeInfo> _activePlugins = {};
  final Map<String, PluginState> _pluginStates = {};

  /// Initialize the plugin registry
  Future<void> initialize() async {
    await _ensurePluginsDirectory();
    await _discoverPlugins();
  }

  /// Discover and load all available plugins
  // ignore: avoid_slow_async_io
  Future<void> _discoverPlugins() async {
    final pluginsDir = Directory(_pluginsDirectory);
    if (!await pluginsDir.exists()) {
      return;
    }

    await for (final entity in pluginsDir.list()) {
      if (entity is Directory) {
        await _loadPluginFromDirectory(entity.path);
      }
    }
  }

  /// Load a plugin from its directory
  // ignore: avoid_slow_async_io
  Future<void> _loadPluginFromDirectory(String pluginPath) async {
    final manifestPath = '$pluginPath/manifest.json';
    final manifestFile = File(manifestPath);

    if (!await manifestFile.exists()) {
      return;
    }

    try {
      final manifestContent = await manifestFile.readAsString();
      final manifest = PluginManifestParser.parse(manifestContent);

      // Validate manifest
      final validationErrors = PluginManifestParser.validate(manifest);
      if (validationErrors.isNotEmpty) {
        for (final error in validationErrors) {
          // Log validation errors
          log(
            'PluginRegistry: manifest validation error for ${manifest.id}: $error',
            name: 'PluginRegistry',
          );
        }
        return;
      }

      _loadedManifests[manifest.id] = manifest;
      _pluginStates[manifest.id] = PluginState.unloaded;
    } catch (e) {
      log(
        'PluginRegistry: failed to load plugin manifest at $manifestPath: $e',
        name: 'PluginRegistry',
      );
    }
  }

  /// Install a plugin from a package/archive
  Future<bool> installPlugin(String pluginPackagePath) async {
    // TODO(user): Implement plugin installation from package
    // This would involve:
    // 1. Extracting the plugin package
    // 2. Validating the manifest
    // 3. Installing dependencies
    // 4. Copying to plugins directory
    throw UnimplementedError('Plugin installation not yet implemented');
  }

  /// Uninstall a plugin
  Future<bool> uninstallPlugin(String pluginId) async {
    if (!_loadedManifests.containsKey(pluginId)) {
      throw PluginRegistryException('Plugin $pluginId is not installed');
    }

    // Unload if active
    if (_pluginStates[pluginId] == PluginState.active) {
      await unloadPlugin(pluginId);
    }

    final manifest = _loadedManifests[pluginId]!;
    final pluginPath = '$_pluginsDirectory/${manifest.id}';

    try {
      final pluginDir = Directory(pluginPath);
      if (await pluginDir.exists()) {
        await pluginDir.delete(recursive: true);
      }

      _loadedManifests.remove(pluginId);
      _pluginStates.remove(pluginId);

      return true;
    } catch (e) {
      // Preserve original behavior but log for visibility
      log(
        'PluginRegistry: failed to uninstall plugin $pluginId: $e',
        name: 'PluginRegistry',
      );
      throw PluginRegistryException('Failed to uninstall plugin $pluginId: $e');
    }
  }

  /// Load and activate a plugin
  Future<bool> loadPlugin(String pluginId) async {
    if (!_loadedManifests.containsKey(pluginId)) {
      throw PluginRegistryException('Plugin $pluginId is not installed');
    }

    if (_pluginStates[pluginId] == PluginState.active) {
      return true; // Already loaded
    }

    final manifest = _loadedManifests[pluginId]!;
    final pluginPath = '$_pluginsDirectory/${manifest.id}';

    try {
      _pluginStates[pluginId] = PluginState.loading;

      // Check dependencies
      if (!await _checkDependencies(manifest)) {
        throw PluginRegistryException(
          'Plugin $pluginId has unsatisfied dependencies',
        );
      }

      // Load plugin in isolate
      final context = PluginLoadContext(
        pluginPath: pluginPath,
        isolationMode: IsolationMode.isolate,
        configuration: {},
      );

      final runtimeInfo = await _isolateManager.loadPlugin(manifest, context);
      _activePlugins[pluginId] = runtimeInfo;

      // Register with IPC manager
      if (runtimeInfo.sendPort != null) {
        _ipcManager.registerPlugin(pluginId, runtimeInfo.sendPort!);
      }

      _pluginStates[pluginId] = PluginState.active;

      return true;
    } catch (e) {
      _pluginStates[pluginId] = PluginState.error;
      throw PluginRegistryException('Failed to load plugin $pluginId: $e');
    }
  }

  /// Unload a plugin
  Future<bool> unloadPlugin(String pluginId) async {
    if (_pluginStates[pluginId] != PluginState.active) {
      return true; // Not loaded
    }

    try {
      await _isolateManager.unloadPlugin(pluginId);
      _ipcManager.unregisterPlugin(pluginId);
      _activePlugins.remove(pluginId);

      _pluginStates[pluginId] = PluginState.unloaded;

      return true;
    } catch (e) {
      throw PluginRegistryException('Failed to unload plugin $pluginId: $e');
    }
  }

  /// Enable a plugin (load if not loaded)
  Future<bool> enablePlugin(String pluginId) async {
    return loadPlugin(pluginId);
  }

  /// Disable a plugin (unload if loaded)
  Future<bool> disablePlugin(String pluginId) async {
    return unloadPlugin(pluginId);
  }

  /// Check if plugin dependencies are satisfied
  Future<bool> _checkDependencies(PluginManifest manifest) async {
    for (final dependency in manifest.dependencies.plugins) {
      if (!_loadedManifests.containsKey(dependency)) {
        return false;
      }

      // Check if dependency is loaded
      if (_pluginStates[dependency] != PluginState.active) {
        // Try to load dependency first
        try {
          await loadPlugin(dependency);
        } catch (e) {
          return false;
        }
      }
    }

    return true;
  }

  /// Get all installed plugins
  List<PluginManifest> getInstalledPlugins() {
    return _loadedManifests.values.toList();
  }

  /// Get active plugins
  List<PluginManifest> getActivePlugins() {
    return _activePlugins.keys
        .map((id) => _loadedManifests[id])
        .where((manifest) => manifest != null)
        .cast<PluginManifest>()
        .toList();
  }

  /// Get plugin manifest by ID
  PluginManifest? getPluginManifest(String pluginId) {
    return _loadedManifests[pluginId];
  }

  /// Get plugin state
  PluginState getPluginState(String pluginId) {
    return _pluginStates[pluginId] ?? PluginState.unloaded;
  }

  /// Get plugin runtime info
  PluginRuntimeInfo? getPluginRuntimeInfo(String pluginId) {
    return _activePlugins[pluginId];
  }

  /// Get plugins by capability
  List<PluginManifest> getPluginsByCapability(String capability) {
    return _loadedManifests.values.where((manifest) {
      return manifest.capabilities.hooks.contains(capability) ||
          manifest.capabilities.commands.contains(capability) ||
          manifest.capabilities.fileExtensions.contains(capability);
    }).toList();
  }

  /// Get plugins that support a file extension
  List<PluginManifest> getPluginsForFileExtension(String extension) {
    return _loadedManifests.values.where((manifest) {
      return manifest.capabilities.fileExtensions.contains(extension);
    }).toList();
  }

  /// Execute a command on a plugin
  Future<CommandResult> executeCommand(
    String pluginId,
    String commandId,
    Map<String, dynamic> args,
  ) async {
    if (_pluginStates[pluginId] != PluginState.active) {
      throw PluginRegistryException('Plugin $pluginId is not active');
    }

    final message = IPCMessage.command(commandId, args);
    final result = await _ipcManager.sendMessage(pluginId, message);

    if (result is CommandResult) {
      return result;
    } else {
      return CommandResult.success(result);
    }
  }

  /// Send a file operation to a plugin
  Future<FileOperationResult> executeFileOperation(
    String pluginId,
    String operation,
    String filePath,
    dynamic data,
  ) async {
    if (_pluginStates[pluginId] != PluginState.active) {
      throw PluginRegistryException('Plugin $pluginId is not active');
    }

    final message = IPCMessage.fileOperation(operation, filePath, data);
    final result = await _ipcManager.sendMessage(pluginId, message);

    if (result is FileOperationResult) {
      return result;
    } else {
      return FileOperationResult.success(data: result);
    }
  }

  /// Ensure plugins directory exists
  // ignore: avoid_slow_async_io
  Future<void> _ensurePluginsDirectory() async {
    final dir = Directory(_pluginsDirectory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Shutdown all plugins
  Future<void> shutdown() async {
    final activePluginIds = _activePlugins.keys.toList();

    for (final pluginId in activePluginIds) {
      try {
        await unloadPlugin(pluginId);
      } catch (e) {
        log(
          'PluginRegistry: failed to unload plugin $pluginId during shutdown: $e',
          name: 'PluginRegistry',
        );
      }
    }
  }
}

/// Exception thrown by the plugin registry
class PluginRegistryException implements Exception {
  PluginRegistryException(this.message);
  final String message;

  @override
  String toString() => 'PluginRegistryException: $message';
}
