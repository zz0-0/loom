import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// Create file use case provider
final createFileUseCaseProvider = Provider<CreateFileUseCase>(
  (ref) => CreateFileUseCase(ref.watch(fileRepositoryProvider)),
);

/// Create directory use case provider
final createDirectoryUseCaseProvider = Provider<CreateDirectoryUseCase>(
  (ref) => CreateDirectoryUseCase(ref.watch(fileRepositoryProvider)),
);
