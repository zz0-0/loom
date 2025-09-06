import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/export/data/repositories/export_repository_impl.dart';
import 'package:loom/features/export/domain/entities/export_entities.dart';
import 'package:loom/features/export/domain/repositories/export_repository.dart';
import 'package:loom/features/export/domain/usecases/export_usecases.dart';

/// Export state
class ExportState {
  const ExportState({
    this.isExporting = false,
    this.lastResult,
    this.errorMessage,
  });

  final bool isExporting;
  final ExportResult? lastResult;
  final String? errorMessage;

  ExportState copyWith({
    bool? isExporting,
    ExportResult? lastResult,
    String? errorMessage,
  }) {
    return ExportState(
      isExporting: isExporting ?? this.isExporting,
      lastResult: lastResult ?? this.lastResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Export provider
class ExportNotifier extends StateNotifier<ExportState> {
  ExportNotifier() : super(const ExportState()) {
    _initializeRepository();
  }

  late final ExportRepository _repository;
  late final ExportContentUseCase _exportContentUseCase;
  late final GetSupportedFormatsUseCase _getSupportedFormatsUseCase;

  void _initializeRepository() {
    _repository = ExportRepositoryImpl();
    _exportContentUseCase = ExportContentUseCase(_repository);
    _getSupportedFormatsUseCase = GetSupportedFormatsUseCase(_repository);
  }

  Future<void> exportContent(ExportRequest request) async {
    state = state.copyWith(isExporting: true);

    try {
      final result = await _exportContentUseCase(request);
      state = state.copyWith(
        isExporting: false,
        lastResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'Export failed: $e',
      );
    }
  }

  List<ExportFormat> getSupportedFormats() {
    return _getSupportedFormatsUseCase();
  }

  String getFileExtension(ExportFormat format) {
    return _repository.getFileExtension(format);
  }
}

final exportProvider = StateNotifierProvider<ExportNotifier, ExportState>(
  (ref) => ExportNotifier(),
);
