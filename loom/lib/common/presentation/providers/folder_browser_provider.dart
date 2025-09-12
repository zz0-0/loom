import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/data/providers.dart';
import 'package:loom/common/domain/repositories/file_repository.dart';
import 'package:path/path.dart' as path;

/// Provider for folder browsing functionality
/// This encapsulates the business logic for browsing directories
final folderBrowserProvider =
    StateNotifierProvider<FolderBrowserNotifier, FolderBrowserState>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return FolderBrowserNotifier(fileRepository);
});

class FolderBrowserState {
  const FolderBrowserState({
    required this.currentPath,
    required this.directories,
    required this.isLoading,
  });

  final String currentPath;
  final List<String> directories;
  final bool isLoading;

  FolderBrowserState copyWith({
    String? currentPath,
    List<String>? directories,
    bool? isLoading,
  }) {
    return FolderBrowserState(
      currentPath: currentPath ?? this.currentPath,
      directories: directories ?? this.directories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FolderBrowserNotifier extends StateNotifier<FolderBrowserState> {
  FolderBrowserNotifier(this._fileRepository)
      : super(
          const FolderBrowserState(
            currentPath: '/',
            directories: [],
            isLoading: false,
          ),
        );

  final FileRepository _fileRepository;

  Future<void> initialize(String initialPath) async {
    state = state.copyWith(currentPath: initialPath, isLoading: true);
    await _loadDirectories();
  }

  Future<void> navigateTo(String path) async {
    state = state.copyWith(currentPath: path, isLoading: true);
    await _loadDirectories();
  }

  Future<void> navigateUp() async {
    final parent = path.dirname(state.currentPath);
    if (parent != state.currentPath) {
      await navigateTo(parent);
    }
  }

  Future<void> _loadDirectories() async {
    try {
      final directoryPaths =
          await _fileRepository.listDirectories(state.currentPath)
            ..sort(
              (String a, String b) => path
                  .basename(a)
                  .toLowerCase()
                  .compareTo(path.basename(b).toLowerCase()),
            );
      state = state.copyWith(directories: directoryPaths, isLoading: false);
    } catch (e) {
      state = state.copyWith(directories: [], isLoading: false);
    }
  }
}
