import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/export/index.dart';

/// Repository providers for dependency injection
final exportRepositoryProvider = Provider<ExportRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return ExportRepositoryImpl(fileRepository);
});
