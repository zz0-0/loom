/// Domain entities for the explorer feature
/// These represent the core business objects and are independent of any framework or data source
library;

/// File category for smart categorization
enum FileCategory {
  development,
  documentation,
  media,
  configuration,
  archive,
  miscellaneous,
}

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

  factory ProjectMetadata.fromJson(Map<String, dynamic> json) {
    return ProjectMetadata(
      version: json['version'] as String? ?? '1.0',
      schemaVersion: json['schemaVersion'] as String? ?? '2023.1',
      collections: (json['collections'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ) ??
          {},
      fileSystemExplorerState: json['fileSystemExplorerState'] != null
          ? FileSystemExplorerState.fromJson(
              json['fileSystemExplorerState'] as Map<String, dynamic>,)
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
      sortedPaths: (json['sortedPaths'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ) ??
          {},
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

/// File/document reference - platform agnostic
class DocumentReference {
  const DocumentReference({
    required this.id,
    required this.path,
    required this.title,
    required this.lastModified,
    this.subtitle,
    this.isModified = false,
    this.iconName,
  });
  final String id;
  final String path;
  final String title;
  final String? subtitle;
  final DateTime lastModified;
  final bool isModified;
  final String? iconName;
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

/// Collection template domain entity
class CollectionTemplate {
  const CollectionTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.filePatterns = const [],
    this.suggestedFiles = const [],
    this.color,
  });

  /// Unique identifier for the template
  final String id;

  /// Display name of the template
  final String name;

  /// Description of what this collection template provides
  final String description;

  /// Icon to display for this template
  final String icon;

  /// File patterns to automatically include (globs)
  final List<String> filePatterns;

  /// Suggested files to include in this collection
  final List<String> suggestedFiles;

  /// Optional color theme for the collection
  final String? color;
}

/// Available collection templates
class CollectionTemplates {
  static const List<CollectionTemplate> templates = [
    CollectionTemplate(
      id: 'development',
      name: 'Development',
      description: 'Code files, documentation, and development resources',
      icon: 'code',
      filePatterns: [
        '*.dart',
        '*.js',
        '*.ts',
        '*.py',
        '*.java',
        '*.cpp',
        '*.c',
        '*.h',
        '*.rs',
        '*.go',
        '*.php',
        '*.rb',
        '*.swift',
        '*.kt',
        '*.scala',
        '*.clj',
        '*.hs',
        '*.ml',
        '*.fs',
        '*.cs',
        '*.vb',
        'README*',
        'CHANGELOG*',
        'CONTRIBUTING*',
        'Dockerfile*',
        '*.md',
        '*.txt',
        '*.json',
        '*.yaml',
        '*.yml',
        '*.toml',
        '*.xml',
        '*.gradle',
        '*.pom',
        'Makefile*',
        '*.sh',
        '*.bat',
        '*.ps1',
      ],
      color: 'blue',
    ),
    CollectionTemplate(
      id: 'documentation',
      name: 'Documentation',
      description: 'Documentation files, guides, and knowledge base',
      icon: 'book',
      filePatterns: [
        '*.md',
        '*.txt',
        '*.rst',
        '*.adoc',
        '*.tex',
        'README*',
        'CHANGELOG*',
        'CONTRIBUTING*',
        'LICENSE*',
        'docs/**',
        'documentation/**',
        'wiki/**',
        '*.pdf',
        '*.docx',
        '*.doc',
      ],
      color: 'green',
    ),
    CollectionTemplate(
      id: 'design',
      name: 'Design Assets',
      description: 'Images, design files, and creative assets',
      icon: 'image',
      filePatterns: [
        '*.png',
        '*.jpg',
        '*.jpeg',
        '*.gif',
        '*.svg',
        '*.webp',
        '*.ico',
        '*.bmp',
        '*.tiff',
        '*.psd',
        '*.ai',
        '*.xd',
        '*.fig',
        '*.sketch',
        '*.afdesign',
        '*.afphoto',
        'assets/**',
        'images/**',
        'img/**',
        'design/**',
        'mockups/**',
        'prototypes/**',
      ],
      color: 'purple',
    ),
    CollectionTemplate(
      id: 'configuration',
      name: 'Configuration',
      description: 'Configuration files, settings, and environment files',
      icon: 'settings',
      filePatterns: [
        '*.json',
        '*.yaml',
        '*.yml',
        '*.toml',
        '*.xml',
        '*.ini',
        '*.cfg',
        '*.conf',
        '*.config',
        '*.properties',
        '*.env',
        '*.env.*',
        'docker-compose*.yml',
        'docker-compose*.yaml',
        '*.dockerfile',
        'Dockerfile*',
        '*.sh',
        '*.bat',
        '*.ps1',
        'Makefile*',
        '*.gradle',
        '*.pom',
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        '.eslintrc*',
        '.prettierrc*',
        '.gitignore',
        '.gitattributes',
      ],
      color: 'orange',
    ),
    CollectionTemplate(
      id: 'research',
      name: 'Research',
      description: 'Research papers, notes, and study materials',
      icon: 'file-text',
      filePatterns: [
        '*.pdf',
        '*.docx',
        '*.doc',
        '*.pptx',
        '*.ppt',
        '*.xlsx',
        '*.xls',
        '*.txt',
        '*.md',
        '*.rtf',
        'research/**',
        'papers/**',
        'notes/**',
        'study/**',
        'references/**',
      ],
      color: 'teal',
    ),
    CollectionTemplate(
      id: 'personal',
      name: 'Personal',
      description: 'Personal files, notes, and miscellaneous items',
      icon: 'heart',
      filePatterns: [
        '*.txt',
        '*.md',
        '*.blox',
        'notes/**',
        'personal/**',
        'journal/**',
        'diary/**',
        'memories/**',
      ],
      color: 'pink',
    ),
    CollectionTemplate(
      id: 'work',
      name: 'Work',
      description: 'Work-related files and professional documents',
      icon: 'briefcase',
      filePatterns: [
        '*.docx',
        '*.doc',
        '*.pptx',
        '*.ppt',
        '*.xlsx',
        '*.xls',
        '*.pdf',
        '*.txt',
        '*.md',
        'work/**',
        'projects/**',
        'meetings/**',
        'reports/**',
        'presentations/**',
      ],
      color: 'indigo',
    ),
    CollectionTemplate(
      id: 'favorites',
      name: 'Favorites',
      description: 'Your favorite and most important files',
      icon: 'star',
      color: 'yellow',
    ),
    CollectionTemplate(
      id: 'archive',
      name: 'Archive',
      description: 'Archived files and completed projects',
      icon: 'folder',
      filePatterns: [
        'archive/**',
        'archived/**',
        'completed/**',
        'finished/**',
        'old/**',
      ],
      color: 'gray',
    ),
  ];

  /// Get a template by its ID
  static CollectionTemplate? getTemplate(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get templates filtered by category
  static List<CollectionTemplate> getTemplatesByCategory(String category) {
    switch (category) {
      case 'development':
        return templates.where((t) => t.id == 'development').toList();
      case 'creative':
        return templates
            .where((t) => ['design', 'research'].contains(t.id))
            .toList();
      case 'work':
        return templates
            .where((t) => ['work', 'configuration'].contains(t.id))
            .toList();
      case 'personal':
        return templates
            .where((t) => ['personal', 'favorites'].contains(t.id))
            .toList();
      case 'organization':
        return templates
            .where((t) => ['documentation', 'archive'].contains(t.id))
            .toList();
      default:
        return templates;
    }
  }
}

/// Project template domain entity
class ProjectTemplate {
  const ProjectTemplate({
    required this.id,
    required this.name,
    required this.description,
    this.files = const [],
    this.folders = const [],
  });

  /// Unique identifier for the template
  final String id;

  /// Display name of the template
  final String name;

  /// Description of what this project template provides
  final String description;

  /// Files to create when using this template
  final List<ProjectFile> files;

  /// Folders to create when using this template
  final List<String> folders;
}

/// Project file to be created from template
class ProjectFile {
  const ProjectFile({
    required this.path,
    required this.content,
  });

  /// Relative path where the file should be created
  final String path;

  /// Content of the file
  final String content;
}
