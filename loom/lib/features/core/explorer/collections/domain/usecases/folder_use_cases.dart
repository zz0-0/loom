import 'package:loom/features/core/explorer/collections/domain/entities/folder.dart';
import 'package:loom/features/core/explorer/collections/domain/repositories/folder_repository.dart';

class FolderCreateDirectoryUseCase {
  FolderCreateDirectoryUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(String rootPath, String directoryPath) async {
    // TODO(user): Implement create directory logic
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
    // TODO(user): Implement create file logic
  }
}

class FolderDeleteItemUseCase {
  FolderDeleteItemUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(String rootPath, String itemPath) async {
    // TODO(user): Implement delete item logic
  }
}

class FolderRenameItemUseCase {
  FolderRenameItemUseCase(this.repository);
  final FolderRepository repository;
  Future<void> call(String rootPath, String oldPath, String newPath) async {
    // TODO(user): Implement rename item logic
  }
}

class RefreshFolderTreeUseCase {
  RefreshFolderTreeUseCase(this.repository);
  final FolderRepository repository;
  Future<List<dynamic>> call(Folder folder) async {
    // TODO(user): Implement refresh folder tree logic
    return folder.fileTree;
  }
}
