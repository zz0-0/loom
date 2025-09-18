import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/plugins/core/plugin_manager.dart';

/// Provider for workspace repository
final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return WorkspaceRepositoryImpl(fileRepository);
});

/// Provider for workspace settings repository
final workspaceSettingsRepositoryProvider =
    Provider<WorkspaceSettingsRepository>((ref) {
  return WorkspaceSettingsRepositoryImpl();
});

/// Provider for create directory use case
final workspaceCreateDirectoryUseCaseProvider =
    Provider<WorkspaceCreateDirectoryUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return WorkspaceCreateDirectoryUseCase(repository);
});

/// Provider for create file use case
final workspaceCreateFileUseCaseProvider =
    Provider<WorkspaceCreateFileUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return WorkspaceCreateFileUseCase(repository);
});

/// Provider for delete item use case
final deleteItemUseCaseProvider = Provider<DeleteItemUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return DeleteItemUseCase(repository);
});

/// Provider for rename item use case
final renameItemUseCaseProvider = Provider<RenameItemUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return RenameItemUseCase(repository);
});

/// Provider for open workspace use case
final openWorkspaceUseCaseProvider = Provider<OpenWorkspaceUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return OpenWorkspaceUseCase(repository);
});

/// Provider for refresh file tree use case
final refreshFileTreeUseCaseProvider = Provider<RefreshFileTreeUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return RefreshFileTreeUseCase(repository);
});

/// State provider for explorer view mode
final explorerViewModeProvider = StateProvider<String>((ref) => 'filesystem');

/// State notifier for workspace settings
class WorkspaceSettingsNotifier extends StateNotifier<WorkspaceSettings> {
  WorkspaceSettingsNotifier(this.repository) : super(const WorkspaceSettings());

  final WorkspaceSettingsRepository repository;

  Future<void> loadSettings(String workspacePath) async {
    try {
      final settings = await repository.loadSettings();
      state = settings;
    } catch (e) {
      // Keep default settings on error
    }
  }

  Future<void> saveSettings(String workspacePath) async {
    await repository.saveSettings(state);
  }

  set updateSettings(WorkspaceSettings value) => state = value;

  WorkspaceSettings get updateSettings => state;

  void setTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  void setFontSize(int fontSize) {
    state = state.copyWith(fontSize: fontSize);
  }

  void setDefaultSidebarView(String view) {
    state = state.copyWith(defaultSidebarView: view);
  }

  void setFilterFileExtensions({required bool filter}) {
    state = state.copyWith(filterFileExtensions: filter);
  }

  void setShowHiddenFiles({required bool show}) {
    state = state.copyWith(showHiddenFiles: show);
  }

  void setWordWrap({required bool wrap}) {
    state = state.copyWith(wordWrap: wrap);
  }

  void toggleFileExtensionFilter() {
    state = state.copyWith(filterFileExtensions: !state.filterFileExtensions);
  }

  void toggleShowHiddenFiles() {
    state = state.copyWith(showHiddenFiles: !state.showHiddenFiles);
  }
}

/// Provider for workspace settings
final workspaceSettingsProvider =
    StateNotifierProvider<WorkspaceSettingsNotifier, WorkspaceSettings>((ref) {
  final repository = ref.watch(workspaceSettingsRepositoryProvider);
  return WorkspaceSettingsNotifier(repository);
});

/// State notifier for current workspace
class WorkspaceNotifier extends StateNotifier<Workspace?> {
  WorkspaceNotifier(
    this.repository,
    this.settingsRepository,
    this.refreshFileTreeUseCase,
    this.createFileUseCase,
    this.createDirectoryUseCase,
    this.deleteItemUseCase,
    this.renameItemUseCase,
  ) : super(null);

  final WorkspaceRepository repository;
  final WorkspaceSettingsRepository settingsRepository;
  final RefreshFileTreeUseCase refreshFileTreeUseCase;
  final WorkspaceCreateFileUseCase createFileUseCase;
  final WorkspaceCreateDirectoryUseCase createDirectoryUseCase;
  final DeleteItemUseCase deleteItemUseCase;
  final RenameItemUseCase renameItemUseCase;

  Future<void> openWorkspace(String path) async {
    try {
      final workspace = await repository.openWorkspace(path);

      // Load workspace settings with fallback to defaults
      final settings = await settingsRepository.loadSettings().catchError(
            (_) => const WorkspaceSettings(), // Fallback to default settings
          );
      final fileTree = await refreshFileTreeUseCase.call(workspace, settings);

      state = workspace.copyWith(
        metadata: workspace.metadata?.copyWith(),
        fileTree: fileTree,
      );

      // Notify plugins about workspace change
      await PluginManager.instance
          .handleLifecycleEvent('workspace_changed', {'path': path});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createWorkspace(String path) async {
    try {
      final workspace = await repository.createWorkspace(path);
      state = workspace;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshFileTree() async {
    if (state == null) return;

    try {
      final settings = await settingsRepository.loadSettings();
      final fileTree = await refreshFileTreeUseCase.call(state!, settings);

      state = state!.copyWith(fileTree: fileTree);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleDirectoryExpansion(String path) async {
    if (state == null) return;

    try {
      final updatedFileTree = _toggleExpansionRecursive(state!.fileTree, path);
      state = state!.copyWith(fileTree: updatedFileTree);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createCollection(String name) async {
    if (state == null) return;

    final collections = Map<String, List<String>>.from(
      state!.metadata?.collections ?? {},
    );

    if (!collections.containsKey(name)) {
      collections[name] = [];
      final metadata = state!.metadata?.copyWith(collections: collections);
      state = state!.copyWith(metadata: metadata);
    }
  }

  Future<void> addToCollection(String collectionName, String filePath) async {
    if (state == null) return;

    final collections = Map<String, List<String>>.from(
      state!.metadata?.collections ?? {},
    );

    final collection = collections[collectionName] ?? [];
    if (!collection.contains(filePath)) {
      collection.add(filePath);
      collections[collectionName] = collection;

      final metadata = state!.metadata?.copyWith(collections: collections);
      state = state!.copyWith(metadata: metadata);
    }
  }

  Future<void> removeFromCollection(
    String collectionName,
    String filePath,
  ) async {
    if (state == null) return;

    final collections = Map<String, List<String>>.from(
      state!.metadata?.collections ?? {},
    );

    final collection = collections[collectionName] ?? []
      ..remove(filePath);

    if (collection.isEmpty) {
      collections.remove(collectionName);
    } else {
      collections[collectionName] = collection;
    }

    final metadata = state!.metadata?.copyWith(collections: collections);
    state = state!.copyWith(metadata: metadata);
  }

  Future<void> createCollectionFromTemplate(
    String templateId,
    String collectionName,
  ) async {
    if (state == null) return;

    // This would integrate with collection templates
    // For now, just create an empty collection
    await createCollection(collectionName);
  }

  Future<void> createFile(String filePath, {String content = ''}) async {
    if (state == null) return;

    try {
      await createFileUseCase.call(state!.rootPath, filePath, content: content);
      await refreshFileTree();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createDirectory(String directoryPath) async {
    if (state == null) return;

    try {
      await createDirectoryUseCase.call(state!.rootPath, directoryPath);
      await refreshFileTree();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(String itemPath) async {
    if (state == null) return;

    try {
      await deleteItemUseCase.call(state!.rootPath, itemPath);
      await refreshFileTree();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> renameItem(String oldPath, String newPath) async {
    if (state == null) return;

    try {
      await renameItemUseCase.call(state!.rootPath, oldPath, newPath);
      await refreshFileTree();
    } catch (e) {
      rethrow;
    }
  }

  List<FileTreeNode> _toggleExpansionRecursive(
    List<FileTreeNode> nodes,
    String targetPath,
  ) {
    return nodes.map((node) {
      if (node.path == targetPath && node.type == FileTreeNodeType.directory) {
        return node.copyWith(isExpanded: !node.isExpanded);
      } else if (node.children.isNotEmpty) {
        final updatedChildren =
            _toggleExpansionRecursive(node.children, targetPath);
        return node.copyWith(children: updatedChildren);
      }
      return node;
    }).toList();
  }

  void closeWorkspace() {
    state = null;
    // Notify plugins that workspace is closed (empty path)
    PluginManager.instance
        .handleLifecycleEvent('workspace_closed', {'path': ''});
  }
}

/// Provider for current workspace
final currentWorkspaceProvider =
    StateNotifierProvider<WorkspaceNotifier, Workspace?>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  final settingsRepository = ref.watch(workspaceSettingsRepositoryProvider);
  final refreshFileTreeUseCase = ref.watch(refreshFileTreeUseCaseProvider);
  final createFileUseCase = ref.watch(workspaceCreateFileUseCaseProvider);
  final createDirectoryUseCase =
      ref.watch(workspaceCreateDirectoryUseCaseProvider);
  final deleteItemUseCase = ref.watch(deleteItemUseCaseProvider);
  final renameItemUseCase = ref.watch(renameItemUseCaseProvider);

  return WorkspaceNotifier(
    repository,
    settingsRepository,
    refreshFileTreeUseCase,
    createFileUseCase,
    createDirectoryUseCase,
    deleteItemUseCase,
    renameItemUseCase,
  );
});

/// Provider for collection templates
final collectionTemplatesProvider = Provider<List<CollectionTemplate>>((ref) {
  return CollectionTemplates.templates;
});
