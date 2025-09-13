/// Export operation result
class ExportResult {
  const ExportResult({
    required this.success,
    required this.filePath,
    this.errorMessage,
    this.fileSize,
  });

  final bool success;
  final String filePath;
  final String? errorMessage;
  final int? fileSize;
}
