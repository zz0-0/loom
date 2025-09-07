import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/export/data/repositories/export_repository_impl.dart';
import 'package:loom/features/export/domain/repositories/export_repository.dart';
import 'package:loom/shared/data/providers.dart';

/// Repository providers for dependency injection
final exportRepositoryProvider = Provider<ExportRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return ExportRepositoryImpl(fileRepository);
});
