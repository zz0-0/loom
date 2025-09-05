/// Data models for JSON serialization
/// These are used by the data layer for external communication
library;

import 'package:loom/features/explorer/domain/entities/workspace_entities.dart';

/// Data model for WorkspaceSettings with JSON serialization
class WorkspaceSettingsModel extends WorkspaceSettings {
  const WorkspaceSettingsModel({
    super.theme = 'dark',
    super.fontSize = 14,
    super.defaultSidebarView = 'filesystem',
    super.filterFileExtensions = true,
    super.showHiddenFiles = false,
    super.wordWrap = true,
  });

  factory WorkspaceSettingsModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceSettingsModel(
      theme: json['theme'] as String? ?? 'dark',
      fontSize: json['fontSize'] as int? ?? 14,
      defaultSidebarView: json['defaultSidebarView'] as String? ?? 'filesystem',
      filterFileExtensions: json['filterFileExtensions'] as bool? ?? true,
      showHiddenFiles: json['showHiddenFiles'] as bool? ?? false,
      wordWrap: json['wordWrap'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'fontSize': fontSize,
      'defaultSidebarView': defaultSidebarView,
      'filterFileExtensions': filterFileExtensions,
      'showHiddenFiles': showHiddenFiles,
      'wordWrap': wordWrap,
    };
  }

  WorkspaceSettings toDomain() => this;
}

/// Data model for ProjectMetadata with JSON serialization
class ProjectMetadataModel extends ProjectMetadata {
  const ProjectMetadataModel({
    super.version = '1.0',
    super.schemaVersion = '2023.1',
    super.collections = const {},
    super.fileSystemExplorerState = const FileSystemExplorerState(),
    super.session = const SessionState(),
    super.migrationHistory = const [],
  });

  factory ProjectMetadataModel.fromJson(Map<String, dynamic> json) {
    return ProjectMetadataModel(
      version: json['version'] as String? ?? '1.0',
      schemaVersion: json['schemaVersion'] as String? ?? '2023.1',
      collections: Map<String, List<String>>.from(
        (json['collections'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
      fileSystemExplorerState: json['fileSystemExplorerState'] != null
          ? FileSystemExplorerStateModel.fromJson(
              json['fileSystemExplorerState'] as Map<String, dynamic>,
            )
          : const FileSystemExplorerState(),
      session: json['session'] != null
          ? SessionStateModel.fromJson(json['session'] as Map<String, dynamic>)
          : const SessionState(),
      migrationHistory:
          List<String>.from(json['migrationHistory'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'schemaVersion': schemaVersion,
      'collections': collections,
      'fileSystemExplorerState':
          (fileSystemExplorerState as FileSystemExplorerStateModel).toJson(),
      'session': (session as SessionStateModel).toJson(),
      'migrationHistory': migrationHistory,
    };
  }

  ProjectMetadata toDomain() => this;
}

/// Data model for FileSystemExplorerState
class FileSystemExplorerStateModel extends FileSystemExplorerState {
  const FileSystemExplorerStateModel({
    super.expandedPaths = const [],
    super.sortedPaths = const {},
  });

  factory FileSystemExplorerStateModel.fromJson(Map<String, dynamic> json) {
    return FileSystemExplorerStateModel(
      expandedPaths: List<String>.from(json['expandedPaths'] as List? ?? []),
      sortedPaths: Map<String, List<String>>.from(
        (json['sortedPaths'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expandedPaths': expandedPaths,
      'sortedPaths': sortedPaths,
    };
  }
}

/// Data model for SessionState
class SessionStateModel extends SessionState {
  const SessionStateModel({
    super.openTabs = const [],
    super.lastActiveFile,
  });

  factory SessionStateModel.fromJson(Map<String, dynamic> json) {
    return SessionStateModel(
      openTabs: List<String>.from(json['openTabs'] as List? ?? []),
      lastActiveFile: json['lastActiveFile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTabs': openTabs,
      'lastActiveFile': lastActiveFile,
    };
  }
}

/// Data model for FileTreeNode with JSON serialization
class FileTreeNodeModel extends FileTreeNode {
  const FileTreeNodeModel({
    required super.name,
    required super.path,
    required super.type,
    super.isExpanded = false,
    super.children = const [],
    super.lastModified,
    super.size,
  });

  factory FileTreeNodeModel.fromJson(Map<String, dynamic> json) {
    return FileTreeNodeModel(
      name: json['name'] as String,
      path: json['path'] as String,
      type: FileTreeNodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FileTreeNodeType.file,
      ),
      isExpanded: json['isExpanded'] as bool? ?? false,
      children: (json['children'] as List<dynamic>? ?? [])
          .map(
            (child) =>
                FileTreeNodeModel.fromJson(child as Map<String, dynamic>),
          )
          .toList(),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type.name,
      'isExpanded': isExpanded,
      'children': children
          .map((child) => (child as FileTreeNodeModel).toJson())
          .toList(),
      'lastModified': lastModified?.toIso8601String(),
      'size': size,
    };
  }
}

/// Data model for Workspace with JSON serialization
class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.name,
    required super.rootPath,
    super.metadata,
    super.fileTree = const [],
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      name: json['name'] as String,
      rootPath: json['rootPath'] as String,
      metadata: json['metadata'] != null
          ? ProjectMetadataModel.fromJson(
              json['metadata'] as Map<String, dynamic>,
            )
          : null,
      fileTree: (json['fileTree'] as List<dynamic>? ?? [])
          .map(
            (node) => FileTreeNodeModel.fromJson(node as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rootPath': rootPath,
      'metadata': (metadata as ProjectMetadataModel?)?.toJson(),
      'fileTree':
          fileTree.map((node) => (node as FileTreeNodeModel).toJson()).toList(),
    };
  }
}
