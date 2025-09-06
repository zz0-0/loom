/// Repository implementations for the data layer
/// These implement the domain repository interfaces and handle data persistence
library;

import 'dart:convert';
import 'dart:io';

import 'package:loom/features/explorer/data/models/workspace_data_models.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart'
    as domain;
import 'package:loom/features/explorer/domain/repositories/workspace_repository.dart';
import 'package:loom/shared/constants/project_constants.dart';
import 'package:loom/shared/utils/file_utils.dart';
import 'package:path/path.dart' as path;

/// Implementation of WorkspaceRepository
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  @override
  Future<domain.Workspace> openWorkspace(String workspacePath) async {
    final directory = Directory(workspacePath);

    if (!directory.existsSync()) {
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
    final directory = Directory(workspacePath);

    if (!directory.existsSync()) {
      await directory.create(recursive: true);
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
    final projectDir =
        Directory(path.join(workspacePath, ProjectConstants.projectDirName));

    if (!projectDir.existsSync()) {
      await projectDir.create(recursive: true);
    }

    final projectFile =
        File(path.join(projectDir.path, ProjectConstants.projectFileName));
    final backupFile = File(
      path.join(projectDir.path, ProjectConstants.projectBackupFileName),
    );

    // Create backup if project file exists
    if (projectFile.existsSync()) {
      await projectFile.copy(backupFile.path);
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
    await projectFile.writeAsString(jsonString);
  }

  @override
  Future<domain.ProjectMetadata> loadProjectMetadata(
    String workspacePath,
  ) async {
    final projectDir =
        Directory(path.join(workspacePath, ProjectConstants.projectDirName));
    final projectFile =
        File(path.join(projectDir.path, ProjectConstants.projectFileName));

    if (!projectFile.existsSync()) {
      return const domain.ProjectMetadata();
    }

    final jsonString = await projectFile.readAsString();
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

    final file = File(filePath);
    final directory = file.parent;

    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    await file.writeAsString(content);
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

    final directory = Directory(directoryPath);
    await directory.create(recursive: true);
  }

  @override
  Future<void> delete(String workspacePath, String itemPath) async {
    // Security: Validate path is within workspace
    final normalizedPath = path.normalize(itemPath);
    final normalizedWorkspacePath = path.normalize(workspacePath);

    if (!path.isWithin(normalizedWorkspacePath, normalizedPath)) {
      throw Exception('Access denied: Path outside workspace');
    }

    final file = File(itemPath);
    final directory = Directory(itemPath);

    if (file.existsSync()) {
      await file.delete();
    } else if (directory.existsSync()) {
      await directory.delete(recursive: true);
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

    final file = File(oldPath);
    final directory = Directory(oldPath);

    if (file.existsSync()) {
      await file.rename(newPath);
    } else if (directory.existsSync()) {
      await directory.rename(newPath);
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
