import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// Provider for file content operations
/// This encapsulates file reading/writing logic to avoid direct data access in presentation
final fileContentProvider =
    StateNotifierProvider<FileContentNotifier, FileContentState>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return FileContentNotifier(fileRepository);
});

class FileContentState {
  const FileContentState({
    this.content = '',
    this.isLoading = false,
    this.error,
  });

  final String content;
  final bool isLoading;
  final String? error;

  FileContentState copyWith({
    String? content,
    bool? isLoading,
    String? error,
  }) {
    return FileContentState(
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FileContentNotifier extends StateNotifier<FileContentState> {
  FileContentNotifier(this._fileRepository) : super(const FileContentState());

  final FileRepository _fileRepository;

  Future<void> loadFile(String filePath) async {
    state = state.copyWith(isLoading: true);
    try {
      final content = await _fileRepository.readFile(filePath);
      state = state.copyWith(content: content, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> saveFile(String filePath, String content) async {
    try {
      await _fileRepository.writeFile(filePath, content);
      state = state.copyWith(content: content);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void clearError() {
    state = state.copyWith();
  }
}
