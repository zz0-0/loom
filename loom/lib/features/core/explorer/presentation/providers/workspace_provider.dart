import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/explorer/data/models/collection_template.dart';
import 'package:loom/features/core/explorer/data/repositories/settings_repository_impl.dart';
import 'package:loom/features/core/explorer/data/repositories/workspace_repository_impl.dart';
import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart';
import 'package:loom/features/core/explorer/domain/repositories/workspace_repository.dart';
import 'package:loom/features/core/explorer/domain/usecases/workspace_usecases.dart';
import 'package:loom/shared/data/providers.dart';

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

/// Provider for create file use case
final createFileUseCaseProvider = Provider<CreateFileUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return CreateFileUseCase(repository);
});

/// Provider for create directory use case
final createDirectoryUseCaseProvider = Provider<CreateDirectoryUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return CreateDirectoryUseCase(repository);
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

  void updateSettings(WorkspaceSettings newSettings) {
    state = newSettings;
  }

  void setTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  void setFontSize(int fontSize) {
    state = state.copyWith(fontSize: fontSize);
  }

  void setDefaultSidebarView(String view) {
    state = state.copyWith(defaultSidebarView: view);
  }

  void setFilterFileExtensions(bool filter) {
    state = state.copyWith(filterFileExtensions: filter);
  }

  void setShowHiddenFiles(bool show) {
    state = state.copyWith(showHiddenFiles: show);
  }

  void setWordWrap(bool wrap) {
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
  ) : super(null);

  final WorkspaceRepository repository;
  final WorkspaceSettingsRepository settingsRepository;
  final RefreshFileTreeUseCase refreshFileTreeUseCase;

  Future<void> openWorkspace(String path) async {
    try {
      final workspace = await repository.openWorkspace(path);

      // Load workspace settings
      final settings = await settingsRepository.loadSettings();
      final fileTree = await refreshFileTreeUseCase.call(workspace, settings);

      state = workspace.copyWith(
        metadata: workspace.metadata?.copyWith(),
        fileTree: fileTree,
      );
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

    final collection = collections[collectionName] ?? [];
    collection.remove(filePath);

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
  }
}

/// Provider for current workspace
final currentWorkspaceProvider =
    StateNotifierProvider<WorkspaceNotifier, Workspace?>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  final settingsRepository = ref.watch(workspaceSettingsRepositoryProvider);
  final refreshFileTreeUseCase = ref.watch(refreshFileTreeUseCaseProvider);

  return WorkspaceNotifier(
    repository,
    settingsRepository,
    refreshFileTreeUseCase,
  );
});

/// Provider for collection templates
final collectionTemplatesProvider =
    Provider<List<CollectionTemplateModel>>((ref) {
  return CollectionTemplates.templates;
});
