import 'package:loom/common/index.dart';

/// Implementation of FileContentService
class FileContentServiceImpl implements FileContentService {
  final ContentParser _parser = ContentParser();
  final SyntaxValidator _validator = SyntaxValidator();
  final SyntaxHighlighter _highlighter = SyntaxHighlighter();
  final MetadataExtractor _extractor = MetadataExtractor();
  final ContentFormatter _formatter = ContentFormatter();

  @override
  Future<Map<String, dynamic>> parseFileContent(
    String content,
    String fileType,
  ) async {
    return _parser.parseFileContent(content, fileType);
  }

  @override
  Future<List<String>> validateSyntax(String content, String fileType) async {
    return _validator.validateSyntax(content, fileType);
  }

  @override
  Future<String> applySyntaxHighlighting(
    String content,
    String fileType,
  ) async {
    return _highlighter.applySyntaxHighlighting(content, fileType);
  }

  @override
  Future<Map<String, dynamic>> extractMetadata(
    String content,
    String fileType,
  ) async {
    return _extractor.extractMetadata(content, fileType);
  }

  @override
  Future<String> formatContent(String content, String fileType) async {
    return _formatter.formatContent(content, fileType);
  }
}
