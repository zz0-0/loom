/// Repository implementations for the data layer
/// These implement the domain repository interfaces and handle data persistence
library;

import 'dart:convert';
import 'dart:io';

import 'package:loom/features/explorer/data/models/workspace_data_models.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart';
import 'package:loom/features/explorer/domain/repositories/workspace_repository.dart';
import 'package:path/path.dart' as path;

/// Implementation of WorkspaceRepository
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  static const String projectDirName = '.loom';
  static const String projectFileName = 'project.json';
  static const String projectBackupFileName = 'project.json.backup';

  @override
  Future<Workspace> openWorkspace(String workspacePath) async {
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

    return Workspace(
      name: workspaceName,
      rootPath: workspacePath,
      metadata: metadata,
      fileTree: fileTree,
    );
  }

  @override
  Future<Workspace> createWorkspace(String workspacePath) async {
    final directory = Directory(workspacePath);

    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    final workspaceName = path.basename(workspacePath);
    const metadata = ProjectMetadata();

    // Save initial project metadata
    await saveProjectMetadata(workspacePath, metadata);

    // Build initial file tree
    final fileTree = await _buildFileTree(workspacePath);

    return Workspace(
      name: workspaceName,
      rootPath: workspacePath,
      metadata: metadata,
      fileTree: fileTree,
    );
  }

  @override
  Future<List<FileTreeNode>> refreshFileTree(
    Workspace workspace,
    WorkspaceSettings settings,
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
    ProjectMetadata metadata,
  ) async {
    final projectDir = Directory(path.join(workspacePath, projectDirName));

    if (!projectDir.existsSync()) {
      await projectDir.create(recursive: true);
    }

    final projectFile = File(path.join(projectDir.path, projectFileName));
    final backupFile = File(path.join(projectDir.path, projectBackupFileName));

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
  Future<ProjectMetadata> loadProjectMetadata(String workspacePath) async {
    final projectDir = Directory(path.join(workspacePath, projectDirName));
    final projectFile = File(path.join(projectDir.path, projectFileName));

    if (!projectFile.existsSync()) {
      return const ProjectMetadata();
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

  Future<List<FileTreeNode>> _buildFileTree(
    String directoryPath, {
    bool filterExtensions = true,
    bool showHiddenFiles = false,
    Set<String>? expandedPaths,
  }) async {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return [];
    }

    final entities = await directory.list().toList();
    final nodes = <FileTreeNode>[];

    // Sort: directories first, then files, alphabetically
    entities.sort((a, b) {
      final aIsDir = a is Directory;
      final bIsDir = b is Directory;

      if (aIsDir && !bIsDir) return -1;
      if (!aIsDir && bIsDir) return 1;

      return path
          .basename(a.path)
          .toLowerCase()
          .compareTo(path.basename(b.path).toLowerCase());
    });

    for (final entity in entities) {
      final entityPath = entity.path;
      final entityName = path.basename(entityPath);

      // Skip hidden files if not showing them
      if (_isHiddenFile(entityPath, showHiddenFiles: showHiddenFiles)) {
        continue;
      }

      if (entity is Directory) {
        final isExpanded = expandedPaths?.contains(entityPath) ?? false;
        final children = isExpanded
            ? await _buildFileTree(
                entityPath,
                filterExtensions: filterExtensions,
                showHiddenFiles: showHiddenFiles,
                expandedPaths: expandedPaths,
              )
            : <FileTreeNode>[];

        nodes.add(
          FileTreeNode(
            name: entityName,
            path: entityPath,
            type: FileTreeNodeType.directory,
            isExpanded: isExpanded,
            children: children,
            lastModified: entity.statSync().modified,
          ),
        );
      } else if (entity is File) {
        // Apply file extension filter
        if (filterExtensions && !_isSupportedFile(entityPath)) {
          continue;
        }

        final stat = entity.statSync();
        nodes.add(
          FileTreeNode(
            name: entityName,
            path: entityPath,
            type: FileTreeNodeType.file,
            lastModified: stat.modified,
            size: stat.size,
          ),
        );
      }
    }

    return nodes;
  }

  bool _isSupportedFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return {'.md', '.markdown', '.blox', '.txt'}.contains(extension);
  }

  bool _isHiddenFile(String filePath, {bool showHiddenFiles = false}) {
    if (showHiddenFiles) return false;

    final fileName = path.basename(filePath);
    return fileName.startsWith('.') ||
        fileName.startsWith('~') ||
        fileName == 'Thumbs.db' ||
        fileName == 'Desktop.ini';
  }
}
