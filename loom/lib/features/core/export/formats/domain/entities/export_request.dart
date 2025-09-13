import 'package:loom/features/core/export/formats/domain/entities/export_options.dart';

/// Export request data
class ExportRequest {
  const ExportRequest({
    required this.content,
    required this.fileName,
    required this.options,
    this.filePath,
  });

  final String content;
  final String fileName;
  final ExportOptions options;
  final String? filePath;
}
