/// User's global application settings stored in OS-specific app data directory
class WorkspaceSettings {
  const WorkspaceSettings({
    this.theme = 'dark',
    this.fontSize = 14,
    this.defaultSidebarView = 'filesystem', // 'filesystem' or 'collections'
    this.filterFileExtensions = true,
    this.showHiddenFiles = false,
    this.wordWrap = true,
  });
  factory WorkspaceSettings.fromJson(Map<String, dynamic> json) {
    return WorkspaceSettings(
      theme: json['theme'] as String? ?? 'dark',
      fontSize: json['fontSize'] as int? ?? 14,
      defaultSidebarView: json['defaultSidebarView'] as String? ?? 'filesystem',
      filterFileExtensions: json['filterFileExtensions'] as bool? ?? true,
      showHiddenFiles: json['showHiddenFiles'] as bool? ?? false,
      wordWrap: json['wordWrap'] as bool? ?? true,
    );
  }

  final String theme;
  final int fontSize;
  final String defaultSidebarView;
  final bool filterFileExtensions;
  final bool showHiddenFiles;
  final bool wordWrap;

  WorkspaceSettings copyWith({
    String? theme,
    int? fontSize,
    String? defaultSidebarView,
    bool? filterFileExtensions,
    bool? showHiddenFiles,
    bool? wordWrap,
  }) {
    return WorkspaceSettings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      defaultSidebarView: defaultSidebarView ?? this.defaultSidebarView,
      filterFileExtensions: filterFileExtensions ?? this.filterFileExtensions,
      showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
      wordWrap: wordWrap ?? this.wordWrap,
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
}

/// Project-specific metadata stored in workspace/.myeditorname/project.json
class ProjectMetadata {
  const ProjectMetadata({
    this.version = '1.0',
    this.schemaVersion = '2023.1',
    this.collections = const {},
    this.fileSystemExplorerState = const FileSystemExplorerState(),
    this.session = const SessionState(),
    this.migrationHistory = const [],
  });
  factory ProjectMetadata.fromJson(Map<String, dynamic> json) {
    return ProjectMetadata(
      version: json['version'] as String? ?? '1.0',
      schemaVersion: json['schemaVersion'] as String? ?? '2023.1',
      collections: Map<String, List<String>>.from(
        (json['collections'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
      fileSystemExplorerState: json['fileSystemExplorerState'] != null
          ? FileSystemExplorerState.fromJson(
              json['fileSystemExplorerState'] as Map<String, dynamic>,
            )
          : const FileSystemExplorerState(),
      session: json['session'] != null
          ? SessionState.fromJson(json['session'] as Map<String, dynamic>)
          : const SessionState(),
      migrationHistory:
          List<String>.from(json['migrationHistory'] as List? ?? []),
    );
  }

  final String version;
  final String schemaVersion;
  final Map<String, List<String>> collections;
  final FileSystemExplorerState fileSystemExplorerState;
  final SessionState session;
  final List<String> migrationHistory;

  ProjectMetadata copyWith({
    String? version,
    String? schemaVersion,
    Map<String, List<String>>? collections,
    FileSystemExplorerState? fileSystemExplorerState,
    SessionState? session,
    List<String>? migrationHistory,
  }) {
    return ProjectMetadata(
      version: version ?? this.version,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      collections: collections ?? this.collections,
      fileSystemExplorerState:
          fileSystemExplorerState ?? this.fileSystemExplorerState,
      session: session ?? this.session,
      migrationHistory: migrationHistory ?? this.migrationHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'schemaVersion': schemaVersion,
      'collections': collections,
      'fileSystemExplorerState': fileSystemExplorerState.toJson(),
      'session': session.toJson(),
      'migrationHistory': migrationHistory,
    };
  }
}

class FileSystemExplorerState {
  const FileSystemExplorerState({
    this.expandedPaths = const [],
    this.sortedPaths = const {},
  });
  factory FileSystemExplorerState.fromJson(Map<String, dynamic> json) {
    return FileSystemExplorerState(
      expandedPaths: List<String>.from(json['expandedPaths'] as List? ?? []),
      sortedPaths: Map<String, List<String>>.from(
        (json['sortedPaths'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
    );
  }

  final List<String> expandedPaths;
  final Map<String, List<String>> sortedPaths; // Custom sort for folders

  FileSystemExplorerState copyWith({
    List<String>? expandedPaths,
    Map<String, List<String>>? sortedPaths,
  }) {
    return FileSystemExplorerState(
      expandedPaths: expandedPaths ?? this.expandedPaths,
      sortedPaths: sortedPaths ?? this.sortedPaths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expandedPaths': expandedPaths,
      'sortedPaths': sortedPaths,
    };
  }
}

class SessionState {
  const SessionState({
    this.openTabs = const [],
    this.lastActiveFile,
  });
  factory SessionState.fromJson(Map<String, dynamic> json) {
    return SessionState(
      openTabs: List<String>.from(json['openTabs'] as List? ?? []),
      lastActiveFile: json['lastActiveFile'] as String?,
    );
  }

  final List<String> openTabs;
  final String? lastActiveFile;

  SessionState copyWith({
    List<String>? openTabs,
    String? lastActiveFile,
  }) {
    return SessionState(
      openTabs: openTabs ?? this.openTabs,
      lastActiveFile: lastActiveFile ?? this.lastActiveFile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTabs': openTabs,
      'lastActiveFile': lastActiveFile,
    };
  }
}

/// File tree node model
class FileTreeNode {
  const FileTreeNode({
    required this.name,
    required this.path,
    required this.type,
    this.isExpanded = false,
    this.children = const [],
    this.lastModified,
    this.size,
  });
  factory FileTreeNode.fromJson(Map<String, dynamic> json) {
    return FileTreeNode(
      name: json['name'] as String,
      path: json['path'] as String,
      type: FileTreeNodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FileTreeNodeType.file,
      ),
      isExpanded: json['isExpanded'] as bool? ?? false,
      children: (json['children'] as List<dynamic>? ?? [])
          .map((child) => FileTreeNode.fromJson(child as Map<String, dynamic>))
          .toList(),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
      size: json['size'] as int?,
    );
  }

  final String name;
  final String path;
  final FileTreeNodeType type;
  final bool isExpanded;
  final List<FileTreeNode> children;
  final DateTime? lastModified;
  final int? size;

  FileTreeNode copyWith({
    String? name,
    String? path,
    FileTreeNodeType? type,
    bool? isExpanded,
    List<FileTreeNode>? children,
    DateTime? lastModified,
    int? size,
  }) {
    return FileTreeNode(
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      isExpanded: isExpanded ?? this.isExpanded,
      children: children ?? this.children,
      lastModified: lastModified ?? this.lastModified,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type.name,
      'isExpanded': isExpanded,
      'children': children.map((child) => child.toJson()).toList(),
      'lastModified': lastModified?.toIso8601String(),
      'size': size,
    };
  }
}

enum FileTreeNodeType {
  file,
  directory,
}

/// Workspace model
class Workspace {
  const Workspace({
    required this.name,
    required this.rootPath,
    this.metadata,
    this.fileTree = const [],
  });
  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      name: json['name'] as String,
      rootPath: json['rootPath'] as String,
      metadata: json['metadata'] != null
          ? ProjectMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      fileTree: (json['fileTree'] as List<dynamic>? ?? [])
          .map((node) => FileTreeNode.fromJson(node as Map<String, dynamic>))
          .toList(),
    );
  }

  final String name;
  final String rootPath;
  final ProjectMetadata? metadata;
  final List<FileTreeNode> fileTree;

  Workspace copyWith({
    String? name,
    String? rootPath,
    ProjectMetadata? metadata,
    List<FileTreeNode>? fileTree,
  }) {
    return Workspace(
      name: name ?? this.name,
      rootPath: rootPath ?? this.rootPath,
      metadata: metadata ?? this.metadata,
      fileTree: fileTree ?? this.fileTree,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rootPath': rootPath,
      'metadata': metadata?.toJson(),
      'fileTree': fileTree.map((node) => node.toJson()).toList(),
    };
  }
}
