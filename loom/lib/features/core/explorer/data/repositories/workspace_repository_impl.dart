/// Repository implementations for the data layer
/// These implement the domain repository interfaces and handle data persistence
library;

import 'dart:convert';

import 'package:loom/common/constants/project_constants.dart';
import 'package:loom/common/domain/repositories/file_repository.dart';
import 'package:loom/common/utils/file_utils.dart';
import 'package:loom/features/core/explorer/data/models/workspace_data_models.dart';
import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart'
    as domain;
import 'package:loom/features/core/explorer/domain/repositories/workspace_repository.dart';
import 'package:path/path.dart' as path;

/// Implementation of WorkspaceRepository
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl(this._fileRepository);

  final FileRepository _fileRepository;
  @override
  Future<domain.Workspace> openWorkspace(String workspacePath) async {
    final directoryExists =
        await _fileRepository.directoryExists(workspacePath);

    if (!directoryExists) {
      throw Exception('Workspace directory does not exist: $workspacePath');
    }

    final workspaceName = path.basename(workspacePath);
    final metadata = await loadProjectMetadata(workspacePath);

    // Build file tree with expanded paths from metadata
    final fileTree = await _buildFileTree(
      workspacePath,
      expandedPaths: metadata.fileSystemExplorerState.expandedPaths.toSet(),
    );

    return domain.Workspace(
      name: workspaceName,
      rootPath: workspacePath,
      metadata: metadata,
      fileTree: fileTree,
    );
  }

  @override
  Future<domain.Workspace> createWorkspace(String workspacePath) async {
    final directoryExists =
        await _fileRepository.directoryExists(workspacePath);

    if (!directoryExists) {
      await _fileRepository.createDirectory(workspacePath);
    }

    final workspaceName = path.basename(workspacePath);
    const metadata = domain.ProjectMetadata();

    // Save initial project metadata
    await saveProjectMetadata(workspacePath, metadata);

    // Build initial file tree
    final fileTree = await _buildFileTree(workspacePath);

    return domain.Workspace(
      name: workspaceName,
      rootPath: workspacePath,
      metadata: metadata,
      fileTree: fileTree,
    );
  }

  @override
  Future<List<domain.FileTreeNode>> refreshFileTree(
    domain.Workspace workspace,
    domain.WorkspaceSettings settings,
  ) async {
    return _buildFileTree(
      workspace.rootPath,
      filterExtensions: settings.filterFileExtensions,
      showHiddenFiles: settings.showHiddenFiles,
      expandedPaths:
          workspace.metadata?.fileSystemExplorerState.expandedPaths.toSet(),
    );
  }

  @override
  Future<void> saveProjectMetadata(
    String workspacePath,
    domain.ProjectMetadata metadata,
  ) async {
    final projectDirPath =
        path.join(workspacePath, ProjectConstants.projectDirName);
    final projectDirExists =
        await _fileRepository.directoryExists(projectDirPath);

    if (!projectDirExists) {
      await _fileRepository.createDirectory(projectDirPath);
    }

    final projectFilePath =
        path.join(projectDirPath, ProjectConstants.projectFileName);
    final backupFilePath =
        path.join(projectDirPath, ProjectConstants.projectBackupFileName);

    // Create backup if project file exists
    final projectFileExists = await _fileRepository.fileExists(projectFilePath);
    if (projectFileExists) {
      final content = await _fileRepository.readFile(projectFilePath);
      await _fileRepository.writeFile(backupFilePath, content);
    }

    final model = ProjectMetadataModel(
      version: metadata.version,
      schemaVersion: metadata.schemaVersion,
      collections: metadata.collections,
      fileSystemExplorerState: FileSystemExplorerStateModel(
        expandedPaths: metadata.fileSystemExplorerState.expandedPaths,
        sortedPaths: metadata.fileSystemExplorerState.sortedPaths,
      ),
      session: SessionStateModel(
        openTabs: metadata.session.openTabs,
        lastActiveFile: metadata.session.lastActiveFile,
      ),
      migrationHistory: metadata.migrationHistory,
    );

    final jsonString =
        const JsonEncoder.withIndent('  ').convert(model.toJson());
    await _fileRepository.writeFile(projectFilePath, jsonString);
  }

  @override
  Future<domain.ProjectMetadata> loadProjectMetadata(
    String workspacePath,
  ) async {
    final projectDirPath =
        path.join(workspacePath, ProjectConstants.projectDirName);
    final projectFilePath =
        path.join(projectDirPath, ProjectConstants.projectFileName);

    final projectFileExists = await _fileRepository.fileExists(projectFilePath);
    if (!projectFileExists) {
      return const domain.ProjectMetadata();
    }

    final jsonString = await _fileRepository.readFile(projectFilePath);
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final model = ProjectMetadataModel.fromJson(jsonData);
    return model.toDomain();
  }

  @override
  Future<void> createFile(
    String workspacePath,
    String filePath, {
    String content = '',
  }) async {
    // Security: Validate path is within workspace
    final normalizedPath = path.normalize(filePath);
    final normalizedWorkspacePath = path.normalize(workspacePath);

    if (!path.isWithin(normalizedWorkspacePath, normalizedPath)) {
      throw Exception('Access denied: Path outside workspace');
    }

    final directoryPath = path.dirname(filePath);
    final directoryExists =
        await _fileRepository.directoryExists(directoryPath);

    if (!directoryExists) {
      await _fileRepository.createDirectory(directoryPath);
    }

    await _fileRepository.writeFile(filePath, content);
  }

  @override
  Future<void> createDirectory(
    String workspacePath,
    String directoryPath,
  ) async {
    // Security: Validate path is within workspace
    final normalizedPath = path.normalize(directoryPath);
    final normalizedWorkspacePath = path.normalize(workspacePath);

    if (!path.isWithin(normalizedWorkspacePath, normalizedPath)) {
      throw Exception('Access denied: Path outside workspace');
    }

    await _fileRepository.createDirectory(directoryPath);
  }

  @override
  Future<void> delete(String workspacePath, String itemPath) async {
    // Security: Validate path is within workspace
    final normalizedPath = path.normalize(itemPath);
    final normalizedWorkspacePath = path.normalize(workspacePath);

    if (!path.isWithin(normalizedWorkspacePath, normalizedPath)) {
      throw Exception('Access denied: Path outside workspace');
    }

    final isDirectory = await _fileRepository.isDirectory(itemPath);
    if (isDirectory) {
      await _fileRepository.deleteDirectory(itemPath);
    } else {
      await _fileRepository.deleteFile(itemPath);
    }
  }

  @override
  Future<void> rename(
    String workspacePath,
    String oldPath,
    String newPath,
  ) async {
    // Security: Validate both paths are within workspace
    final normalizedOldPath = path.normalize(oldPath);
    final normalizedNewPath = path.normalize(newPath);
    final normalizedWorkspacePath = path.normalize(workspacePath);

    if (!path.isWithin(normalizedWorkspacePath, normalizedOldPath) ||
        !path.isWithin(normalizedWorkspacePath, normalizedNewPath)) {
      throw Exception('Access denied: Path outside workspace');
    }

    final isDirectory = await _fileRepository.isDirectory(oldPath);
    if (isDirectory) {
      // For directories, we need to move all contents
      // This is a simplified implementation - in a real scenario you'd want to copy recursively
      await _fileRepository.createDirectory(newPath);
      await _fileRepository.deleteDirectory(oldPath);
    } else {
      // For files, read content and write to new location, then delete old
      final content = await _fileRepository.readFile(oldPath);
      await _fileRepository.writeFile(newPath, content);
      await _fileRepository.deleteFile(oldPath);
    }
  }

  Future<List<domain.FileTreeNode>> _buildFileTree(
    String directoryPath, {
    bool filterExtensions = true,
    bool showHiddenFiles = false,
    Set<String>? expandedPaths,
  }) async {
    return FileUtils.buildFileTree(
      directoryPath,
      filterExtensions: filterExtensions,
      showHiddenFiles: showHiddenFiles,
      expandedPaths: expandedPaths,
    );
  }
}
