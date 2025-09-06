import 'package:loom/features/export/domain/entities/export_entities.dart';
import 'package:loom/features/export/domain/repositories/export_repository.dart';

/// Use case for exporting content
class ExportContentUseCase {
  const ExportContentUseCase(this.repository);

  final ExportRepository repository;

  Future<ExportResult> call(ExportRequest request) async {
    return repository.exportContent(request);
  }
}

/// Use case for getting supported formats
class GetSupportedFormatsUseCase {
  const GetSupportedFormatsUseCase(this.repository);

  final ExportRepository repository;

  List<ExportFormat> call() {
    return repository.getSupportedFormats();
  }
}

/// Use case for validating export format
class ValidateExportFormatUseCase {
  const ValidateExportFormatUseCase(this.repository);

  final ExportRepository repository;

  bool call(ExportFormat format) {
    return repository.isFormatSupported(format);
  }
}
