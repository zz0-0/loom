import 'package:loom/features/core/explorer/collections/domain/entities/folder.dart';

abstract class FolderRepository {
  Future<Folder> openFolder(String path);
  Future<Folder> createFolder(String path);
}

class FolderRepositoryImpl implements FolderRepository {
  FolderRepositoryImpl(this.fileRepository);
  final dynamic fileRepository;

  @override
  Future<Folder> openFolder(String path) async {
    // TODO(user): Implement openFolder logic
    return Folder(rootPath: path);
  }

  @override
  Future<Folder> createFolder(String path) async {
    // TODO(user): Implement createFolder logic
    return Folder(rootPath: path);
  }
}
