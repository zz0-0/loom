import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';
import 'package:path/path.dart' as path;

/// Service for filtering files based on search criteria
class FileFilterService {
  const FileFilterService(this._fileRepository);

  final FileRepository _fileRepository;

  /// Get all files in workspace that match the search criteria
  Future<List<String>> getFilteredFiles(
    String workspacePath,
    SearchQuery query,
  ) async {
    final allFiles = await _fileRepository.listFilesRecursively(workspacePath);

    return allFiles.where((filePath) {
      // Skip hidden files unless explicitly included
      if (!query.includeHiddenFiles &&
          path.basename(filePath).startsWith('.')) {
        return false;
      }

      // Check file extension filter
      if (query.fileExtensions.isNotEmpty) {
        final extension = path.extension(filePath).toLowerCase();
        if (!query.fileExtensions.contains(extension)) {
          return false;
        }
      }

      // Check exclude patterns
      for (final pattern in query.excludePatterns) {
        if (filePath.contains(pattern)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
