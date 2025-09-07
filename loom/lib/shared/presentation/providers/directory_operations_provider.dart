import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/data/providers.dart';
import 'package:loom/shared/domain/repositories/file_repository.dart';

/// Provider for directory operations
/// This encapsulates directory checking logic to avoid direct data access in presentation
final directoryOperationsProvider = StateNotifierProvider<
    DirectoryOperationsNotifier, DirectoryOperationsState>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return DirectoryOperationsNotifier(fileRepository);
});

class DirectoryOperationsState {
  const DirectoryOperationsState({
    this.isValid = false,
    this.isChecking = false,
    this.error,
  });

  final bool isValid;
  final bool isChecking;
  final String? error;

  DirectoryOperationsState copyWith({
    bool? isValid,
    bool? isChecking,
    String? error,
  }) {
    return DirectoryOperationsState(
      isValid: isValid ?? this.isValid,
      isChecking: isChecking ?? this.isChecking,
      error: error ?? this.error,
    );
  }
}

class DirectoryOperationsNotifier
    extends StateNotifier<DirectoryOperationsState> {
  DirectoryOperationsNotifier(this._fileRepository)
      : super(const DirectoryOperationsState());

  final FileRepository _fileRepository;

  Future<void> validateDirectory(String directoryPath) async {
    state = state.copyWith(isChecking: true);
    try {
      await _fileRepository.listDirectories(directoryPath);
      state = state.copyWith(isValid: true, isChecking: false);
    } catch (e) {
      state = state.copyWith(
          isValid: false, isChecking: false, error: e.toString(),);
    }
  }

  void clearError() {
    state = state.copyWith();
  }
}
