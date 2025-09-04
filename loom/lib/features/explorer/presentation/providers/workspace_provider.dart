import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/models/workspace_settings.dart'
    as models;
import 'package:loom/features/explorer/data/services/workspace_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_provider.g.dart';

/// Current workspace state
@Riverpod(keepAlive: true)
class CurrentWorkspace extends _$CurrentWorkspace {
  @override
  models.Workspace? build() {
    return null;
  }

  /// Open a workspace from the given path
  Future<void> openWorkspace(String path) async {
    final workspaceService = ref.read(workspaceServiceProvider);
    try {
      state = await workspaceService.openWorkspace(path);
    } catch (e) {
      // Handle error - could emit an error state or show notification
      rethrow;
    }
  }

  /// Create a new workspace at the given path
  Future<void> createWorkspace(String path) async {
    final workspaceService = ref.read(workspaceServiceProvider);
    try {
      state = await workspaceService.createWorkspace(path);
    } catch (e) {
      rethrow;
    }
  }

  /// Close current workspace
  void closeWorkspace() {
    state = null;
  }

  /// Refresh file tree
  Future<void> refreshFileTree() async {
    if (state == null) return;

    final workspaceService = ref.read(workspaceServiceProvider);
    final settings = ref.read(workspaceSettingsProvider);

    try {
      final newFileTree =
          await workspaceService.refreshFileTree(state!, settings);
      state = state!.copyWith(fileTree: newFileTree);
    } catch (e) {
      // Handle error
    }
  }

  /// Toggle directory expansion
  Future<void> toggleDirectoryExpansion(String directoryPath) async {
    if (state?.metadata == null) return;

    final currentState = state!.metadata!;
    final expandedPaths =
        List<String>.from(currentState.fileSystemExplorerState.expandedPaths);

    if (expandedPaths.contains(directoryPath)) {
      expandedPaths.remove(directoryPath);
    } else {
      expandedPaths.add(directoryPath);
    }

    final newExplorerState = currentState.fileSystemExplorerState.copyWith(
      expandedPaths: expandedPaths,
    );

    final newMetadata = currentState.copyWith(
      fileSystemExplorerState: newExplorerState,
    );

    state = state!.copyWith(metadata: newMetadata);

    // Save metadata and refresh file tree
    final workspaceService = ref.read(workspaceServiceProvider);
    await workspaceService.saveProjectMetadata(state!.rootPath, newMetadata);
    await refreshFileTree();
  }

  /// Add file to collection
  Future<void> addToCollection(String collectionName, String filePath) async {
    if (state?.metadata == null) return;

    final currentMetadata = state!.metadata!;
    final collections =
        Map<String, List<String>>.from(currentMetadata.collections);

    if (!collections.containsKey(collectionName)) {
      collections[collectionName] = [];
    }

    if (!collections[collectionName]!.contains(filePath)) {
      collections[collectionName]!.add(filePath);
    }

    final newMetadata = currentMetadata.copyWith(collections: collections);
    state = state!.copyWith(metadata: newMetadata);

    // Save metadata
    final workspaceService = ref.read(workspaceServiceProvider);
    await workspaceService.saveProjectMetadata(state!.rootPath, newMetadata);
  }

  /// Remove file from collection
  Future<void> removeFromCollection(
    String collectionName,
    String filePath,
  ) async {
    if (state?.metadata == null) return;

    final currentMetadata = state!.metadata!;
    final collections =
        Map<String, List<String>>.from(currentMetadata.collections);

    if (collections.containsKey(collectionName)) {
      collections[collectionName]!.remove(filePath);

      // Remove empty collections
      if (collections[collectionName]!.isEmpty) {
        collections.remove(collectionName);
      }
    }

    final newMetadata = currentMetadata.copyWith(collections: collections);
    state = state!.copyWith(metadata: newMetadata);

    // Save metadata
    final workspaceService = ref.read(workspaceServiceProvider);
    await workspaceService.saveProjectMetadata(state!.rootPath, newMetadata);
  }

  /// Create new collection
  Future<void> createCollection(String collectionName) async {
    if (state?.metadata == null) return;

    final currentMetadata = state!.metadata!;
    final collections =
        Map<String, List<String>>.from(currentMetadata.collections);

    if (!collections.containsKey(collectionName)) {
      collections[collectionName] = [];

      final newMetadata = currentMetadata.copyWith(collections: collections);
      state = state!.copyWith(metadata: newMetadata);

      // Save metadata
      final workspaceService = ref.read(workspaceServiceProvider);
      await workspaceService.saveProjectMetadata(state!.rootPath, newMetadata);
    }
  }
}

/// Workspace settings state provider
final workspaceSettingsProvider =
    StateNotifierProvider<WorkspaceSettingsNotifier, models.WorkspaceSettings>(
        (ref) {
  return WorkspaceSettingsNotifier(ref);
});

class WorkspaceSettingsNotifier
    extends StateNotifier<models.WorkspaceSettings> {
  WorkspaceSettingsNotifier(this.ref)
      : super(const models.WorkspaceSettings()) {
    _loadSettings();
  }

  final Ref ref;

  Future<void> _loadSettings() async {
    final workspaceService = ref.read(workspaceServiceProvider);
    try {
      final settings = await workspaceService.loadSettings();
      state = settings;
    } catch (e) {
      // Use default settings if loading fails
      state = const models.WorkspaceSettings();
    }
  }

  /// Update settings and save
  Future<void> updateSettings(models.WorkspaceSettings newSettings) async {
    state = newSettings;

    final workspaceService = ref.read(workspaceServiceProvider);
    try {
      await workspaceService.saveSettings(newSettings);

      // Refresh file tree if filter settings changed
      await ref.read(currentWorkspaceProvider.notifier).refreshFileTree();
    } catch (e) {
      // Handle error
    }
  }

  /// Toggle file extension filtering
  Future<void> toggleFileExtensionFilter() async {
    await updateSettings(
      state.copyWith(filterFileExtensions: !state.filterFileExtensions),
    );
  }

  /// Toggle show hidden files
  Future<void> toggleShowHiddenFiles() async {
    await updateSettings(
      state.copyWith(showHiddenFiles: !state.showHiddenFiles),
    );
  }

  /// Set default sidebar view
  Future<void> setDefaultSidebarView(String view) async {
    await updateSettings(state.copyWith(defaultSidebarView: view));
  }
}

/// Explorer view mode (filesystem or collections)
@riverpod
class ExplorerViewMode extends _$ExplorerViewMode {
  @override
  String build() {
    final settings = ref.watch(workspaceSettingsProvider);
    return settings.defaultSidebarView;
  }

  void setViewMode(String mode) {
    state = mode;
  }

  void toggleViewMode() {
    state = state == 'filesystem' ? 'collections' : 'filesystem';
  }
}

/// Currently selected sidebar view
@riverpod
class SelectedSidebarView extends _$SelectedSidebarView {
  @override
  String? build() {
    return null;
  }

  void selectView(String view) {
    state = view;
  }

  void clearSelection() {
    state = null;
  }
}
