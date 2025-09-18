import 'package:loom/features/core/explorer/collections/domain/entities/folder.dart';
import 'package:loom/features/core/explorer/collections/domain/repositories/folder_repository.dart';

class FolderCreateDirectoryUseCase {
  FolderCreateDirectoryUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(String rootPath, String directoryPath) async {
    await repository.createDirectory(rootPath, directoryPath);
  }
}

class FolderCreateFileUseCase {
  FolderCreateFileUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(
    String rootPath,
    String filePath, {
    String content = '',
  }) async {
    await repository.createFile(rootPath, filePath, content: content);
  }
}

class FolderDeleteItemUseCase {
  FolderDeleteItemUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(String rootPath, String itemPath) async {
    await repository.deleteItem(rootPath, itemPath);
  }
}

class FolderRenameItemUseCase {
  FolderRenameItemUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(String rootPath, String oldPath, String newPath) async {
    await repository.renameItem(rootPath, oldPath, newPath);
  }
}

class RefreshFolderTreeUseCase {
  RefreshFolderTreeUseCase(this.repository);
  final FolderRepository repository;
  Future<List<dynamic>> call(Folder folder) async {
    return repository.refreshFileTree(folder.rootPath);
  }
}
