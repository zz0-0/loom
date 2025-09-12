import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/data/providers.dart';
import 'package:loom/features/core/export/data/repositories/export_repository_impl.dart';
import 'package:loom/features/core/export/domain/repositories/export_repository.dart';

/// Repository providers for dependency injection
final exportRepositoryProvider = Provider<ExportRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return ExportRepositoryImpl(fileRepository);
});
