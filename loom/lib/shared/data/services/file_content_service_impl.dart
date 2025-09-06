import 'package:loom/shared/domain/services/file_content_service.dart';

/// Implementation of FileContentService
class FileContentServiceImpl implements FileContentService {
  @override
  Future<Map<String, dynamic>> parseFileContent(
    String content,
    String fileType,
  ) async {
    // Basic parsing logic - can be extended for specific file types
    final lines = content.split('\n');
    final metadata = <String, dynamic>{
      'lineCount': lines.length,
      'characterCount': content.length,
      'fileType': fileType,
    };

    return metadata;
  }

  @override
  Future<List<String>> validateSyntax(String content, String fileType) async {
    // Basic syntax validation - can be extended for specific file types
    final warnings = <String>[];

    if (content.isEmpty) {
      warnings.add('File is empty');
    }

    // Add file-type specific validation here
    if (fileType == 'blox') {
      // Blox-specific validation could be added here
    }

    return warnings;
  }

  @override
  Future<String> applySyntaxHighlighting(
    String content,
    String fileType,
  ) async {
    // Basic syntax highlighting - can be extended for specific file types
    return content; // For now, return as-is
  }

  @override
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

  @override
  Future<String> formatContent(String content, String fileType) async {
    // Basic formatting - can be extended for specific file types
    final lines = content.split('\n');
    final formattedLines = lines.map((line) => line.trimRight()).toList();
    return formattedLines.join('\n');
  }
}
