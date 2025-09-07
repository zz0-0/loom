import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/plugin_explorer/data/explorer_data.dart';
import 'package:loom/features/plugin_explorer/domain/explorer_domain.dart';
import 'package:loom/shared/data/providers.dart';
import 'package:loom/shared/domain/repositories/file_repository.dart';

// Providers for dependency injection
final fileSystemRepositoryProvider = Provider<FileSystemRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return FileSystemRepositoryImpl(fileRepository);
});

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  return WorkspaceRepositoryImpl();
});

final explorerDataSourceProvider = Provider<ExplorerDataSource>((ref) {
  return LocalExplorerDataSource();
});

// State management for Explorer
final explorerStateProvider =
    StateNotifierProvider<ExplorerNotifier, ExplorerState>((ref) {
  final fileSystemRepo = ref.watch(fileSystemRepositoryProvider);
  final workspaceRepo = ref.watch(workspaceRepositoryProvider);
  final dataSource = ref.watch(explorerDataSourceProvider);
  final fileRepository = ref.watch(fileRepositoryProvider);

  return ExplorerNotifier(
    fileSystemRepository: fileSystemRepo,
    workspaceRepository: workspaceRepo,
    dataSource: dataSource,
    fileRepository: fileRepository,
  );
});

class ExplorerState {
  const ExplorerState({
    this.currentPath,
    this.files = const [],
    this.isLoading = false,
    this.error,
    this.viewMode = 'filesystem',
    this.showHiddenFiles = false,
  });

  final String? currentPath;
  final List<String> files;
  final bool isLoading;
  final String? error;
  final String viewMode;
  final bool showHiddenFiles;

  ExplorerState copyWith({
    String? currentPath,
    List<String>? files,
    bool? isLoading,
    String? error,
    String? viewMode,
    bool? showHiddenFiles,
  }) {
    return ExplorerState(
      currentPath: currentPath ?? this.currentPath,
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      viewMode: viewMode ?? this.viewMode,
      showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
    );
  }
}

class ExplorerNotifier extends StateNotifier<ExplorerState> {
  ExplorerNotifier({
    required this.fileSystemRepository,
    required this.workspaceRepository,
    required this.dataSource,
    required this.fileRepository,
  }) : super(const ExplorerState());

  final FileSystemRepository fileSystemRepository;
  final WorkspaceRepository workspaceRepository;
  final ExplorerDataSource dataSource;
  final FileRepository fileRepository;

  Future<void> loadDirectory(String path) async {
    state = state.copyWith(isLoading: true);

    try {
      final files = await fileSystemRepository.listDirectory(path);
      state = state.copyWith(
        currentPath: path,
        files: files,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createFile(String name) async {
    if (state.currentPath == null) return;

    try {
      final filePath = '${state.currentPath}/$name';
      await fileSystemRepository.createFile(filePath);
      await loadDirectory(state.currentPath!); // Refresh
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createFolder(String name) async {
    if (state.currentPath == null) return;

    try {
      final folderPath = '${state.currentPath}/$name';
      await fileSystemRepository.createDirectory(folderPath);
      await loadDirectory(state.currentPath!); // Refresh
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteItem(String path) async {
    try {
      final exists = await fileRepository.fileExists(path);
      final isDir = await fileRepository.isDirectory(path);

      if (exists) {
        if (isDir) {
          await fileSystemRepository.deleteDirectory(path);
        } else {
          await fileSystemRepository.deleteFile(path);
        }
      }
      await loadDirectory(state.currentPath!); // Refresh
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setViewMode(String mode) {
    state = state.copyWith(viewMode: mode);
  }

  void toggleHiddenFiles() {
    state = state.copyWith(showHiddenFiles: !state.showHiddenFiles);
  }
}

// UI Components for Explorer Plugin
class ExplorerPanelWidget extends ConsumerWidget {
  const ExplorerPanelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(explorerStateProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text('Error: ${state.error}'),
      );
    }

    return Column(
      children: [
        // Toolbar
        ExplorerToolbar(
          viewMode: state.viewMode,
          onViewModeChanged: (mode) {
            ref.read(explorerStateProvider.notifier).setViewMode(mode);
          },
          onRefresh: () {
            if (state.currentPath != null) {
              ref
                  .read(explorerStateProvider.notifier)
                  .loadDirectory(state.currentPath!);
            }
          },
          onCreateFile: () => _showCreateFileDialog(context, ref),
          onCreateFolder: () => _showCreateFolderDialog(context, ref),
        ),

        // Content
        Expanded(
          child: switch (state.viewMode) {
            'filesystem' => FileSystemView(files: state.files),
            'collections' => const CollectionsView(),
            _ => FileSystemView(files: state.files),
          },
        ),
      ],
    );
  }

  void _showCreateFileDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => CreateItemDialog(
        title: 'Create New File',
        onCreate: (name) {
          ref.read(explorerStateProvider.notifier).createFile(name);
        },
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => CreateItemDialog(
        title: 'Create New Folder',
        onCreate: (name) {
          ref.read(explorerStateProvider.notifier).createFolder(name);
        },
      ),
    );
  }
}

class ExplorerToolbar extends StatelessWidget {
  const ExplorerToolbar({
    required this.viewMode, required this.onViewModeChanged, required this.onRefresh, required this.onCreateFile, required this.onCreateFolder, super.key,
  });

  final String viewMode;
  final ValueChanged<String> onViewModeChanged;
  final VoidCallback onRefresh;
  final VoidCallback onCreateFile;
  final VoidCallback onCreateFolder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onCreateFile,
          tooltip: 'New File',
        ),
        IconButton(
          icon: const Icon(Icons.create_new_folder),
          onPressed: onCreateFolder,
          tooltip: 'New Folder',
        ),
        const Spacer(),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'filesystem', label: Text('Files')),
            ButtonSegment(value: 'collections', label: Text('Collections')),
          ],
          selected: {viewMode},
          onSelectionChanged: (selection) {
            onViewModeChanged(selection.first);
          },
        ),
      ],
    );
  }
}

class FileSystemView extends ConsumerWidget {
  const FileSystemView({required this.files, super.key});

  final List<String> files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final path = files[index];
        final name = path.split('/').last;

        return FutureBuilder<bool>(
          future: ref.read(fileRepositoryProvider).isDirectory(path),
          builder: (context, snapshot) {
            final isDirectory = snapshot.data ?? false;
            return ListTile(
              leading: Icon(isDirectory ? Icons.folder : Icons.file_present),
              title: Text(name),
              onTap: () {
                // Handle file/directory selection
              },
            );
          },
        );
      },
    );
  }
}

class CollectionsView extends StatelessWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Collections view - Coming soon!'),
    );
  }
}

class CreateItemDialog extends StatefulWidget {
  const CreateItemDialog({
    required this.title, required this.onCreate, super.key,
  });

  final String title;
  final ValueChanged<String> onCreate;

  @override
  State<CreateItemDialog> createState() => _CreateItemDialogState();
}

class _CreateItemDialogState extends State<CreateItemDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Name',
          hintText: 'Enter name',
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onCreate(value);
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onCreate(_controller.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
