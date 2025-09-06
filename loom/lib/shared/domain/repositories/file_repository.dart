import 'dart:io';

/// Repository interface for file operations
/// This abstracts file system operations for the domain layer
abstract class FileRepository {
  /// Reads the content of a file at the given path
  Future<String> readFile(String path);

  /// Writes content to a file at the given path
  Future<void> writeFile(String path, String content);

  /// Checks if a file exists at the given path
  Future<bool> fileExists(String path);

  /// Gets the directory at the given path
  Future<Directory> getDirectory(String path);

  /// Lists all directories in the given directory path
  Future<List<Directory>> listDirectories(String path);

  /// Creates a directory at the given path
  Future<void> createDirectory(String path);

  /// Deletes a file at the given path
  Future<void> deleteFile(String path);
}
