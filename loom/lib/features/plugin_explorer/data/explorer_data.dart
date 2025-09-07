import 'package:loom/features/plugin_explorer/domain/explorer_domain.dart';
import 'package:loom/shared/domain/repositories/file_repository.dart';

/// Implementation of FileSystemRepository using shared FileRepository
class FileSystemRepositoryImpl implements FileSystemRepository {
  FileSystemRepositoryImpl(this._fileRepository);

  final FileRepository _fileRepository;

  @override
  Future<List<String>> listDirectory(String path) async {
    return _fileRepository.listDirectories(path);
  }

  @override
  Future<void> createFile(String path) async {
    await _fileRepository.writeFile(path, '');
  }

  @override
  Future<void> createDirectory(String path) async {
    await _fileRepository.createDirectory(path);
  }

  @override
  Future<void> deleteFile(String path) async {
    await _fileRepository.deleteFile(path);
  }

  @override
  Future<void> deleteDirectory(String path) async {
    await _fileRepository.deleteDirectory(path);
  }
}

/// Implementation of WorkspaceRepository
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  String? _currentWorkspace;

  @override
  Future<String?> getCurrentWorkspace() async {
    return _currentWorkspace;
  }

  @override
  Future<void> setCurrentWorkspace(String path) async {
    _currentWorkspace = path;
    // TODO(user): Persist to storage
  }

  @override
  Stream<String?> watchCurrentWorkspace() {
    // TODO(user): Implement stream for workspace changes
    return Stream.value(_currentWorkspace);
  }
}

/// Data sources for Explorer plugin
abstract class ExplorerDataSource {
  Future<List<String>> getRecentFiles();
  Future<void> addRecentFile(String path);
  Future<List<String>> getFavoriteDirectories();
  Future<void> addFavoriteDirectory(String path);
  Future<void> removeFavoriteDirectory(String path);
}

class LocalExplorerDataSource implements ExplorerDataSource {
  // TODO(user): Implement using shared_preferences or local storage
  @override
  Future<List<String>> getRecentFiles() async {
    return [];
  }

  @override
  Future<void> addRecentFile(String path) async {
    // Save to local storage
  }

  @override
  Future<List<String>> getFavoriteDirectories() async {
    return [];
  }

  @override
  Future<void> addFavoriteDirectory(String path) async {
    // Save to local storage
  }

  @override
  Future<void> removeFavoriteDirectory(String path) async {
    // Remove from local storage
  }
}
