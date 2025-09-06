/// Service for handling file content operations
/// Contains business logic for parsing, validation, and content manipulation
abstract class FileContentService {
  /// Parses the content of a file and returns structured data
  Future<Map<String, dynamic>> parseFileContent(
    String content,
    String fileType,
  );

  /// Validates the syntax of file content
  Future<List<String>> validateSyntax(String content, String fileType);

  /// Applies syntax highlighting to content
  Future<String> applySyntaxHighlighting(String content, String fileType);

  /// Extracts metadata from file content
  Future<Map<String, dynamic>> extractMetadata(String content, String fileType);

  /// Formats content according to file type standards
  Future<String> formatContent(String content, String fileType);
}
