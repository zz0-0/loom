import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/models/workspace_settings.dart';
import 'package:loom/shared/constants/project_constants.dart';
import 'package:loom/shared/utils/file_utils.dart';
import 'package:path/path.dart' as path;

/// Service for managing workspace operations (file system, metadata, settings)
class WorkspaceService {
  static const String settingsFileName = 'settings.json';

  /// Get OS-specific application data directory
  String getAppDataDirectory() {
    // For now, use home directory - in production, use proper app data directory
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '.';
    return path.join(home, '.loom');
  }

  /// Load global user settings
  Future<WorkspaceSettings> loadSettings() async {
    try {
      final appDataDir = getAppDataDirectory();
      final settingsFile = File(path.join(appDataDir, settingsFileName));

      if (!settingsFile.existsSync()) {
        return const WorkspaceSettings();
      }

      final jsonString = await settingsFile.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      return WorkspaceSettings.fromJson(jsonData);
    } catch (e) {
      // Return default settings if loading fails
      return const WorkspaceSettings();
    }
  }

  /// Save global user settings
  Future<void> saveSettings(WorkspaceSettings settings) async {
    try {
      final appDataDir = getAppDataDirectory();
      final appDataDirectory = Directory(appDataDir);

      if (!appDataDirectory.existsSync()) {
        await appDataDirectory.create(recursive: true);
      }

      final settingsFile = File(path.join(appDataDir, settingsFileName));
      final jsonString =
          const JsonEncoder.withIndent('  ').convert(settings.toJson());
      await settingsFile.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  /// Load project metadata from workspace
  Future<ProjectMetadata> loadProjectMetadata(String workspacePath) async {
    try {
      final projectDir =
          Directory(path.join(workspacePath, ProjectConstants.projectDirName));
      final projectFile =
          File(path.join(projectDir.path, ProjectConstants.projectFileName));

      if (!projectFile.existsSync()) {
        return const ProjectMetadata();
      }

      final jsonString = await projectFile.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      return ProjectMetadata.fromJson(jsonData);
    } catch (e) {
      // Try to load from backup
      try {
        final projectDir = Directory(
          path.join(workspacePath, ProjectConstants.projectDirName),
        );
        final backupFile = File(
          path.join(projectDir.path, ProjectConstants.projectBackupFileName),
        );

        if (backupFile.existsSync()) {
          final jsonString = await backupFile.readAsString();
          final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
          return ProjectMetadata.fromJson(jsonData);
        }
      } catch (_) {
        // Ignore backup loading errors
      }

      // Return default metadata if loading fails
      return const ProjectMetadata();
    }
  }

  /// Save project metadata to workspace
  Future<void> saveProjectMetadata(
    String workspacePath,
    ProjectMetadata metadata,
  ) async {
    try {
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

      final jsonString =
          const JsonEncoder.withIndent('  ').convert(metadata.toJson());
      await projectFile.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to save project metadata: $e');
    }
  }

  /// Get supported file extensions
  Set<String> getSupportedExtensions() {
    return FileUtils.getSupportedExtensions();
  }

  /// Check if file extension is supported
  bool isSupportedFile(String filePath) {
    return FileUtils.isSupportedFile(filePath);
  }

  /// Check if file should be hidden
  bool isHiddenFile(String filePath, {bool showHiddenFiles = false}) {
    return FileUtils.isHiddenFile(filePath, showHiddenFiles: showHiddenFiles);
  }

  /// Build file tree from directory
  Future<List<FileTreeNode>> buildFileTree(
    String directoryPath, {
    bool filterExtensions = true,
    bool showHiddenFiles = false,
    Set<String>? expandedPaths,
  }) async {
    final result = await FileUtils.buildFileTree(
      directoryPath,
      filterExtensions: filterExtensions,
      showHiddenFiles: showHiddenFiles,
      expandedPaths: expandedPaths,
    );
    return result as List<FileTreeNode>;
  }

  /// Create a new workspace
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
    final fileTree = await buildFileTree(workspacePath);

    return Workspace(
      name: workspaceName,
      rootPath: workspacePath,
      metadata: metadata,
      fileTree: fileTree,
    );
  }

  /// Open existing workspace
  Future<Workspace> openWorkspace(String workspacePath) async {
    final directory = Directory(workspacePath);

    if (!directory.existsSync()) {
      throw Exception('Workspace directory does not exist: $workspacePath');
    }

    final workspaceName = path.basename(workspacePath);
    final metadata = await loadProjectMetadata(workspacePath);

    // Build file tree with expanded paths from metadata
    final fileTree = await buildFileTree(
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

  /// Refresh workspace file tree
  Future<List<FileTreeNode>> refreshFileTree(
    Workspace workspace,
    WorkspaceSettings settings,
  ) async {
    return buildFileTree(
      workspace.rootPath,
      filterExtensions: settings.filterFileExtensions,
      showHiddenFiles: settings.showHiddenFiles,
      expandedPaths:
          workspace.metadata?.fileSystemExplorerState.expandedPaths.toSet(),
    );
  }

  /// Create new file
  Future<void> createFile(String filePath, {String content = ''}) async {
    final file = File(filePath);
    final directory = file.parent;

    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    await file.writeAsString(content);
  }

  /// Create new directory
  Future<void> createDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);
    await directory.create(recursive: true);
  }

  /// Delete file or directory
  Future<void> delete(String itemPath) async {
    final file = File(itemPath);
    final directory = Directory(itemPath);

    if (file.existsSync()) {
      await file.delete();
    } else if (directory.existsSync()) {
      await directory.delete(recursive: true);
    }
  }

  /// Rename file or directory
  Future<void> rename(String oldPath, String newPath) async {
    final file = File(oldPath);
    final directory = Directory(oldPath);

    if (file.existsSync()) {
      await file.rename(newPath);
    } else if (directory.existsSync()) {
      await directory.rename(newPath);
    }
  }
}

/// Provider for workspace service
final workspaceServiceProvider = Provider<WorkspaceService>((ref) {
  return WorkspaceService();
});
