import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Represents a project template that can be used to create new projects
class ProjectTemplate {
  const ProjectTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.files,
    this.folders = const [],
  });

  /// Unique identifier for the template
  final String id;

  /// Display name of the template
  final String name;

  /// Description of what this template provides
  final String description;

  /// Icon to display in the UI
  final IconData icon;

  /// List of files to create with their content
  final List<ProjectFile> files;

  /// List of folders to create
  final List<String> folders;
}

/// Represents a file to be created in a project
class ProjectFile {
  const ProjectFile({
    required this.path,
    required this.content,
  });

  /// Relative path of the file within the project
  final String path;

  /// Content of the file
  final String content;
}

/// Available project templates
class ProjectTemplates {
  static const List<ProjectTemplate> templates = [
    ProjectTemplate(
      id: 'empty',
      name: 'Empty Project',
      description: 'Start with a blank slate',
      icon: LucideIcons.file,
      files: [
        ProjectFile(
          path: 'README.md',
          content: '''
# New Project

Welcome to your new project!

## Getting Started

This is a blank project. You can start adding your files and organizing your content however you like.

## Tips

- Create folders to organize your content
- Use markdown files for notes and documentation
- Keep a consistent naming convention
- Don't forget to update this README as your project grows
''',
        ),
      ],
    ),
  ];

  /// Get a template by its ID
  static ProjectTemplate? getTemplate(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }
}
