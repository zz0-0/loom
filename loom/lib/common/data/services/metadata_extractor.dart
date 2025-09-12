/// Service for extracting metadata from file content
class MetadataExtractor {
  /// Extracts metadata from file content
  Future<Map<String, dynamic>> extractMetadata(
    String content,
    String fileType,
  ) async {
    final lines = content.split('\n');
    return {
      'lineCount': lines.length,
      'characterCount': content.length,
      'wordCount':
          content.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length,
      'fileType': fileType,
    };
  }
}
