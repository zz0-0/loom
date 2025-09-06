import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/export/data/repositories/export_repository_impl.dart';
import 'package:loom/features/export/domain/repositories/export_repository.dart';

/// Repository providers for dependency injection
final exportRepositoryProvider = Provider<ExportRepository>((ref) {
  return ExportRepositoryImpl();
});
