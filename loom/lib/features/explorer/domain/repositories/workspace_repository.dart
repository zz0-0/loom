/// Repository interfaces for the explorer domain
/// These define the contracts that data layer implementations must follow
library;

import 'package:loom/features/explorer/domain/entities/workspace_entities.dart';

/// Repository for workspace operations
abstract class WorkspaceRepository {
  /// Open existing workspace
  Future<Workspace> openWorkspace(String path);

  /// Create a new workspace
  Future<Workspace> createWorkspace(String path);

  /// Refresh workspace file tree
  Future<List<FileTreeNode>> refreshFileTree(
    Workspace workspace,
    WorkspaceSettings settings,
  );

  /// Save project metadata
  Future<void> saveProjectMetadata(
    String workspacePath,
    ProjectMetadata metadata,
  );

  /// Load project metadata
  Future<ProjectMetadata> loadProjectMetadata(String workspacePath);

  /// Create new file
  Future<void> createFile(
    String workspacePath,
    String filePath, {
    String content = '',
  });

  /// Create new directory
  Future<void> createDirectory(String workspacePath, String directoryPath);

  /// Delete file or directory
  Future<void> delete(String workspacePath, String itemPath);

  /// Rename file or directory
  Future<void> rename(String workspacePath, String oldPath, String newPath);
}

/// Repository for workspace settings
abstract class WorkspaceSettingsRepository {
  /// Load global user settings
  Future<WorkspaceSettings> loadSettings();

  /// Save global user settings
  Future<void> saveSettings(WorkspaceSettings settings);
}
