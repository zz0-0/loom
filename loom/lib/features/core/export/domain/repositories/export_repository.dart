import 'package:loom/features/core/export/index.dart';

/// Repository interface for export operations
abstract class ExportRepository {
  /// Export content to the specified format
  Future<ExportResult> exportContent(ExportRequest request);

  /// Get supported export formats
  List<ExportFormat> getSupportedFormats();

  /// Check if a format is supported
  bool isFormatSupported(ExportFormat format);

  /// Get file extension for a format
  String getFileExtension(ExportFormat format);
}
