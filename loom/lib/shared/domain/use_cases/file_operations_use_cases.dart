import 'package:loom/shared/domain/repositories/file_repository.dart';

/// Use case for creating a file
class CreateFileUseCase {
  CreateFileUseCase(this._fileRepository);

  final FileRepository _fileRepository;

  Future<void> call(String workspacePath, String filePath) async {
    // Basic validation - ensure the file is within the workspace
    if (!filePath.startsWith(workspacePath)) {
      throw Exception('File path must be within the workspace');
    }

    // Check if file already exists
    if (await _fileRepository.fileExists(filePath)) {
      throw Exception('File already exists');
    }

    // Create the file
    await _fileRepository.createFile(filePath);
  }
}

/// Use case for creating a directory
class CreateDirectoryUseCase {
  CreateDirectoryUseCase(this._fileRepository);

  final FileRepository _fileRepository;

  Future<void> call(String workspacePath, String directoryPath) async {
    // Basic validation - ensure the directory is within the workspace
    if (!directoryPath.startsWith(workspacePath)) {
      throw Exception('Directory path must be within the workspace');
    }

    // Check if directory already exists
    if (await _fileRepository.directoryExists(directoryPath)) {
      throw Exception('Directory already exists');
    }

    // Create the directory
    await _fileRepository.createDirectory(directoryPath);
  }
}
