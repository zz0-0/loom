import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/repositories/settings_repository_impl.dart';
import 'package:loom/features/explorer/data/repositories/workspace_repository_impl.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart'
    as domain;
import 'package:loom/features/explorer/domain/repositories/workspace_repository.dart';
import 'package:loom/features/explorer/domain/usecases/settings_usecases.dart';
import 'package:loom/features/explorer/domain/usecases/workspace_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_provider.g.dart';

/// Current workspace state
@Riverpod(keepAlive: true)
class CurrentWorkspace extends _$CurrentWorkspace {
  @override
  domain.Workspace? build() {
    return null;
  }

  /// Open a workspace from the given path
  Future<void> openWorkspace(String path) async {
    final useCase = ref.read(openWorkspaceUseCaseProvider);
    try {
      state = await useCase.call(path);
    } catch (e) {
      // Handle error - could emit an error state or show notification
      rethrow;
    }
  }

  /// Create a new workspace at the given path
  Future<void> createWorkspace(String path) async {
    final useCase = ref.read(createWorkspaceUseCaseProvider);
    try {
      state = await useCase.call(path);
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

    final useCase = ref.read(refreshFileTreeUseCaseProvider);
    final settings = ref.read(workspaceSettingsProvider);

    try {
      final newFileTree = await useCase.call(state!, settings);
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
    final useCase = ref.read(saveProjectMetadataUseCaseProvider);
    await useCase.call(state!.rootPath, newMetadata);
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
    final useCase = ref.read(saveProjectMetadataUseCaseProvider);
    await useCase.call(state!.rootPath, newMetadata);
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
    final useCase = ref.read(saveProjectMetadataUseCaseProvider);
    await useCase.call(state!.rootPath, newMetadata);
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
      final useCase = ref.read(saveProjectMetadataUseCaseProvider);
      await useCase.call(state!.rootPath, newMetadata);
    }
  }
}

/// Workspace settings state provider
final workspaceSettingsProvider =
    StateNotifierProvider<WorkspaceSettingsNotifier, domain.WorkspaceSettings>(
        (ref) {
  return WorkspaceSettingsNotifier(ref);
});

class WorkspaceSettingsNotifier
    extends StateNotifier<domain.WorkspaceSettings> {
  WorkspaceSettingsNotifier(this.ref)
      : super(const domain.WorkspaceSettings()) {
    _loadSettings();
  }

  final Ref ref;

  Future<void> _loadSettings() async {
    final useCase = ref.read(loadSettingsUseCaseProvider);
    try {
      final settings = await useCase.call();
      state = settings;
    } catch (e) {
      // Use default settings if loading fails
      state = const domain.WorkspaceSettings();
    }
  }

  /// Update settings and save
  Future<void> updateSettings(domain.WorkspaceSettings newSettings) async {
    state = newSettings;

    final useCase = ref.read(saveSettingsUseCaseProvider);
    try {
      await useCase.call(newSettings);

      // Refresh file tree if filter settings changed
      await ref.read(currentWorkspaceProvider.notifier).refreshFileTree();
    } catch (e) {
      // Handle error
    }
  }

  /// Toggle file extension filtering
  Future<void> toggleFileExtensionFilter() async {
    final useCase = ref.read(toggleFileExtensionFilterUseCaseProvider);
    final newSettings = await useCase.call(state);
    state = newSettings;

    // Refresh file tree
    await ref.read(currentWorkspaceProvider.notifier).refreshFileTree();
  }

  /// Toggle show hidden files
  Future<void> toggleShowHiddenFiles() async {
    final useCase = ref.read(toggleShowHiddenFilesUseCaseProvider);
    final newSettings = await useCase.call(state);
    state = newSettings;

    // Refresh file tree
    await ref.read(currentWorkspaceProvider.notifier).refreshFileTree();
  }

  /// Set default sidebar view
  Future<void> setDefaultSidebarView(String view) async {
    final useCase = ref.read(setDefaultSidebarViewUseCaseProvider);
    final newSettings = await useCase.call(state, view);
    state = newSettings;
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

  String get viewMode => state;

  set viewMode(String mode) {
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

  String? get selectedView => state;

  set selectedView(String? view) {
    state = view;
  }

  void clearSelection() {
    state = null;
  }
}

/// Repository providers
final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepositoryImpl();
});

final workspaceSettingsRepositoryProvider =
    Provider<WorkspaceSettingsRepository>((ref) {
  return WorkspaceSettingsRepositoryImpl();
});

/// Use case providers
final openWorkspaceUseCaseProvider = Provider<OpenWorkspaceUseCase>((ref) {
  final repository = ref.read(workspaceRepositoryProvider);
  return OpenWorkspaceUseCase(repository);
});

final createWorkspaceUseCaseProvider = Provider<CreateWorkspaceUseCase>((ref) {
  final repository = ref.read(workspaceRepositoryProvider);
  return CreateWorkspaceUseCase(repository);
});

final refreshFileTreeUseCaseProvider = Provider<RefreshFileTreeUseCase>((ref) {
  final repository = ref.read(workspaceRepositoryProvider);
  return RefreshFileTreeUseCase(repository);
});

final saveProjectMetadataUseCaseProvider =
    Provider<SaveProjectMetadataUseCase>((ref) {
  final repository = ref.read(workspaceRepositoryProvider);
  return SaveProjectMetadataUseCase(repository);
});

final loadSettingsUseCaseProvider = Provider<LoadSettingsUseCase>((ref) {
  final repository = ref.read(workspaceSettingsRepositoryProvider);
  return LoadSettingsUseCase(repository);
});

final saveSettingsUseCaseProvider = Provider<SaveSettingsUseCase>((ref) {
  final repository = ref.read(workspaceSettingsRepositoryProvider);
  return SaveSettingsUseCase(repository);
});

final toggleFileExtensionFilterUseCaseProvider =
    Provider<ToggleFileExtensionFilterUseCase>((ref) {
  final repository = ref.read(workspaceSettingsRepositoryProvider);
  return ToggleFileExtensionFilterUseCase(repository);
});

final toggleShowHiddenFilesUseCaseProvider =
    Provider<ToggleShowHiddenFilesUseCase>((ref) {
  final repository = ref.read(workspaceSettingsRepositoryProvider);
  return ToggleShowHiddenFilesUseCase(repository);
});

final setDefaultSidebarViewUseCaseProvider =
    Provider<SetDefaultSidebarViewUseCase>((ref) {
  final repository = ref.read(workspaceSettingsRepositoryProvider);
  return SetDefaultSidebarViewUseCase(repository);
});
