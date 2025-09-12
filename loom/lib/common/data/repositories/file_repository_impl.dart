import 'dart:io';
import 'package:loom/common/domain/repositories/file_repository.dart';

/// Implementation of FileRepository using dart:io
class FileRepositoryImpl implements FileRepository {
  @override
  Future<String> readFile(String path) async {
    final file = File(path);
    return file.readAsString();
  }

  @override
  Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
  }

  @override
  Future<bool> fileExists(String path) async {
    final file = File(path);
    return file.existsSync();
  }

  @override
  Future<List<String>> listDirectories(String path) async {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }

    final entities = await dir.list().toList();
    return entities
        .whereType<Directory>()
        .where((d) => !d.path.split('/').last.startsWith('.'))
        .map((d) => d.path)
        .toList();
  }

  @override
  Future<List<String>> listFiles(String path) async {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }

    final entities = await dir.list().toList();
    return entities
        .whereType<File>()
        .where((f) => !f.path.split('/').last.startsWith('.'))
        .map((f) => f.path)
        .toList();
  }

  @override
  Future<List<String>> listFilesRecursively(String path) async {
    final files = <String>[];
    await _collectFilesRecursively(Directory(path), files);
    return files;
  }

  Future<void> _collectFilesRecursively(
    Directory dir,
    List<String> files,
  ) async {
    try {
      await for (final entity in dir.list()) {
        if (entity is File) {
          // Skip hidden files
          if (!entity.path.split('/').last.startsWith('.')) {
            files.add(entity.path);
          }
        } else if (entity is Directory) {
          // Skip hidden directories and common build directories
          final dirName = entity.path.split('/').last;
          if (!dirName.startsWith('.') &&
              !['node_modules', 'build', '.dart_tool', 'android', 'ios', '.git']
                  .contains(dirName)) {
            await _collectFilesRecursively(entity, files);
          }
        }
      }
    } catch (e) {
      // Skip directories that can't be read
    }
  }

  @override
  Future<void> createFile(String path, [String content = '']) async {
    final file = File(path);
    await file.create(recursive: true);
    if (content.isNotEmpty) {
      await file.writeAsString(content);
    }
  }

  @override
  Future<void> createDirectory(String path) async {
    final dir = Directory(path);
    await dir.create(recursive: true);
  }

  @override
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override
  Future<void> deleteDirectory(String path) async {
    final directory = Directory(path);
    if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  }

  @override
  Future<bool> directoryExists(String path) async {
    final directory = Directory(path);
    return directory.existsSync();
  }

  @override
  Future<bool> isDirectory(String path) async {
    final directory = Directory(path);
    return directory.existsSync() &&
        directory.statSync().type == FileSystemEntityType.directory;
  }
}
