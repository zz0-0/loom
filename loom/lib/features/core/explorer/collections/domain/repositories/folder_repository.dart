import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/collections/domain/entities/file_tree_node.dart';
import 'package:loom/features/core/explorer/collections/domain/entities/folder.dart';

abstract class FolderRepository {
  Future<Folder> openFolder(String path);
  Future<Folder> createFolder(String path);
  Future<void> createFile(
    String rootPath,
    String filePath, {
    String content = '',
  });
  Future<void> createDirectory(String rootPath, String directoryPath);
  Future<void> deleteItem(String rootPath, String itemPath);
  Future<void> renameItem(String rootPath, String oldPath, String newPath);
  Future<List<FileTreeNode>> refreshFileTree(String rootPath);
}

class FolderRepositoryImpl implements FolderRepository {
  FolderRepositoryImpl(this.fileRepository);
  final FileRepository fileRepository;

  @override
  Future<Folder> openFolder(String path) async {
    final directoryExists = await fileRepository.directoryExists(path);
    if (!directoryExists) {
      throw Exception('Folder directory does not exist: $path');
    }

    final fileTree = await refreshFileTree(path);
    return Folder(rootPath: path, fileTree: fileTree);
  }

  @override
  Future<Folder> createFolder(String path) async {
    final directoryExists = await fileRepository.directoryExists(path);
    if (!directoryExists) {
      await fileRepository.createDirectory(path);
    }

    final fileTree = await refreshFileTree(path);
    return Folder(rootPath: path, fileTree: fileTree);
  }

  @override
  Future<void> createFile(
    String rootPath,
    String filePath, {
    String content = '',
  }) async {
    // Security: Validate path is within root path
    if (!filePath.startsWith(rootPath)) {
      throw Exception('Access denied: Path outside folder');
    }

    final directoryPath = filePath.substring(0, filePath.lastIndexOf('/'));
    final directoryExists = await fileRepository.directoryExists(directoryPath);

    if (!directoryExists) {
      await fileRepository.createDirectory(directoryPath);
    }

    await fileRepository.writeFile(filePath, content);
  }

  @override
  Future<void> createDirectory(String rootPath, String directoryPath) async {
    // Security: Validate path is within root path
    if (!directoryPath.startsWith(rootPath)) {
      throw Exception('Access denied: Path outside folder');
    }

    await fileRepository.createDirectory(directoryPath);
  }

  @override
  Future<void> deleteItem(String rootPath, String itemPath) async {
    // Security: Validate path is within root path
    if (!itemPath.startsWith(rootPath)) {
      throw Exception('Access denied: Path outside folder');
    }

    final isDirectory = await fileRepository.isDirectory(itemPath);
    if (isDirectory) {
      await fileRepository.deleteDirectory(itemPath);
    } else {
      await fileRepository.deleteFile(itemPath);
    }
  }

  @override
  Future<void> renameItem(
    String rootPath,
    String oldPath,
    String newPath,
  ) async {
    // Security: Validate both paths are within root path
    if (!oldPath.startsWith(rootPath) || !newPath.startsWith(rootPath)) {
      throw Exception('Access denied: Path outside folder');
    }

    final isDirectory = await fileRepository.isDirectory(oldPath);
    if (isDirectory) {
      // For directories, create new and delete old (simplified)
      await fileRepository.createDirectory(newPath);
      await fileRepository.deleteDirectory(oldPath);
    } else {
      // For files, read content and write to new location, then delete old
      final content = await fileRepository.readFile(oldPath);
      await fileRepository.writeFile(newPath, content);
      await fileRepository.deleteFile(oldPath);
    }
  }

  @override
  Future<List<FileTreeNode>> refreshFileTree(String rootPath) async {
    return FileUtils.buildFileTree(rootPath);
  }
}
