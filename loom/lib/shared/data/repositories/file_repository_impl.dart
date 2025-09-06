import 'dart:io';
import 'package:loom/shared/domain/repositories/file_repository.dart';

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
  Future<Directory> getDirectory(String path) async {
    return Directory(path);
  }

  @override
  Future<List<Directory>> listDirectories(String path) async {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }

    final entities = await dir.list().toList();
    return entities
        .whereType<Directory>()
        .where((d) => !d.path.split('/').last.startsWith('.'))
        .toList();
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
}
