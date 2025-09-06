import 'package:flutter/material.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// UI model for collection template with icon data
class CollectionTemplateModel extends CollectionTemplate {
  const CollectionTemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.icon,
    super.filePatterns,
    super.suggestedFiles,
    super.color,
  });

  /// Convert to domain entity
  CollectionTemplate toDomain() => CollectionTemplate(
        id: id,
        name: name,
        description: description,
        icon: icon,
        filePatterns: filePatterns,
        suggestedFiles: suggestedFiles,
        color: color,
      );

  /// Get the IconData for this template
  IconData get iconData {
    switch (icon) {
      case 'code':
        return LucideIcons.code;
      case 'book':
        return LucideIcons.book;
      case 'file-text':
        return LucideIcons.fileText;
      case 'image':
        return LucideIcons.image;
      case 'settings':
        return LucideIcons.settings;
      case 'users':
        return LucideIcons.users;
      case 'briefcase':
        return LucideIcons.briefcase;
      case 'heart':
        return LucideIcons.heart;
      case 'star':
        return LucideIcons.star;
      case 'folder':
        return LucideIcons.folder;
      default:
        return LucideIcons.star;
    }
  }
}

/// Available collection templates
class CollectionTemplates {
  static const List<CollectionTemplateModel> templates = [
    CollectionTemplateModel(
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
    CollectionTemplateModel(
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
    CollectionTemplateModel(
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
    CollectionTemplateModel(
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
    CollectionTemplateModel(
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
    CollectionTemplateModel(
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
    CollectionTemplateModel(
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
    CollectionTemplateModel(
      id: 'favorites',
      name: 'Favorites',
      description: 'Your favorite and most important files',
      icon: 'star',
      color: 'yellow',
    ),
    CollectionTemplateModel(
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
  static CollectionTemplateModel? getTemplate(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get templates as domain entities
  static List<CollectionTemplate> getDomainTemplates() {
    return templates.map((t) => t.toDomain()).toList();
  }

  /// Get templates filtered by category
  static List<CollectionTemplateModel> getTemplatesByCategory(String category) {
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
