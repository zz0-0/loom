/// Use cases for workspace operations
/// These contain the business logic and orchestrate repository calls
library;

import 'package:loom/features/explorer/domain/entities/workspace_entities.dart';
import 'package:loom/features/explorer/domain/repositories/workspace_repository.dart';

/// Use case for opening a workspace
class OpenWorkspaceUseCase {
  const OpenWorkspaceUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<Workspace> call(String path) async {
    return repository.openWorkspace(path);
  }
}

/// Use case for creating a workspace
class CreateWorkspaceUseCase {
  const CreateWorkspaceUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<Workspace> call(String path) async {
    return repository.createWorkspace(path);
  }
}

/// Use case for refreshing file tree
class RefreshFileTreeUseCase {
  const RefreshFileTreeUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<List<FileTreeNode>> call(
    Workspace workspace,
    WorkspaceSettings settings,
  ) async {
    return repository.refreshFileTree(workspace, settings);
  }
}

/// Use case for saving project metadata
class SaveProjectMetadataUseCase {
  const SaveProjectMetadataUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<void> call(String workspacePath, ProjectMetadata metadata) async {
    return repository.saveProjectMetadata(workspacePath, metadata);
  }
}

/// Use case for loading project metadata
class LoadProjectMetadataUseCase {
  const LoadProjectMetadataUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<ProjectMetadata> call(String workspacePath) async {
    return repository.loadProjectMetadata(workspacePath);
  }
}

/// Use case for creating a file
class CreateFileUseCase {
  const CreateFileUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<void> call(
    String workspacePath,
    String filePath, {
    String content = '',
  }) async {
    return repository.createFile(workspacePath, filePath, content: content);
  }
}

/// Use case for creating a directory
class CreateDirectoryUseCase {
  const CreateDirectoryUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<void> call(String workspacePath, String directoryPath) async {
    return repository.createDirectory(workspacePath, directoryPath);
  }
}

/// Use case for deleting a file or directory
class DeleteItemUseCase {
  const DeleteItemUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<void> call(String workspacePath, String itemPath) async {
    return repository.delete(workspacePath, itemPath);
  }
}

/// Use case for renaming a file or directory
class RenameItemUseCase {
  const RenameItemUseCase(this.repository);

  final WorkspaceRepository repository;

  Future<void> call(
    String workspacePath,
    String oldPath,
    String newPath,
  ) async {
    return repository.rename(workspacePath, oldPath, newPath);
  }
}
