/// Repository interface for file operations
/// This abstracts file system operations for the domain layer
abstract class FileRepository {
  /// Reads the content of a file at the given path
  Future<String> readFile(String path);

  /// Writes content to a file at the given path
  Future<void> writeFile(String path, String content);

  /// Checks if a file exists at the given path
  Future<bool> fileExists(String path);

  /// Lists all directories in the given directory path
  Future<List<String>> listDirectories(String path);

  /// Lists all files in the given directory path (non-recursive)
  Future<List<String>> listFiles(String path);

  /// Lists all files recursively in the given directory path
  Future<List<String>> listFilesRecursively(String path);

  /// Creates a directory at the given path
  Future<void> createDirectory(String path);

  /// Deletes a file at the given path
  Future<void> deleteFile(String path);

  /// Deletes a directory at the given path
  Future<void> deleteDirectory(String path);

  /// Checks if a directory exists at the given path
  Future<bool> directoryExists(String path);

  /// Checks if the given path is a directory
  Future<bool> isDirectory(String path);
}
