/// Service for validating syntax of file content
class SyntaxValidator {
  /// Validates the syntax of file content
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
}
