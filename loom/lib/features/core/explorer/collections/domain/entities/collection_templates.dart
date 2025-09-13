import 'package:loom/features/core/explorer/collections/domain/entities/collection_template.dart';

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
