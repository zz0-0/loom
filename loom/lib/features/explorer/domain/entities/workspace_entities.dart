/// Domain entities for the explorer feature
/// These represent the core business objects and are independent of any framework or data source
library;

/// User's global application settings
class WorkspaceSettings {
  const WorkspaceSettings({
    this.theme = 'dark',
    this.fontSize = 14,
    this.defaultSidebarView = 'filesystem', // 'filesystem' or 'collections'
    this.filterFileExtensions = true,
    this.showHiddenFiles = false,
    this.wordWrap = true,
  });

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
}

/// Project-specific metadata
class ProjectMetadata {
  const ProjectMetadata({
    this.version = '1.0',
    this.schemaVersion = '2023.1',
    this.collections = const {},
    this.fileSystemExplorerState = const FileSystemExplorerState(),
    this.session = const SessionState(),
    this.migrationHistory = const [],
  });

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
}

class FileSystemExplorerState {
  const FileSystemExplorerState({
    this.expandedPaths = const [],
    this.sortedPaths = const {},
  });

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
}

class SessionState {
  const SessionState({
    this.openTabs = const [],
    this.lastActiveFile,
  });

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
}

/// File tree node domain entity
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
}

enum FileTreeNodeType {
  file,
  directory,
}

/// Workspace domain entity
class Workspace {
  const Workspace({
    required this.name,
    required this.rootPath,
    this.metadata,
    this.fileTree = const [],
  });

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
}
