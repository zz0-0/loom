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
          path: 'welcome.blox',
          content: '''
#document title="Welcome to Loom"

#section title="Getting Started"
This is your new Loom project! Loom uses the Blox format for structured documents.

#section title="What is Blox?"
Blox is a powerful markup language designed for modern knowledge management. It combines the simplicity of Markdown with structured data capabilities.

## Features
- **Structured Content**: Organize your thoughts with clear hierarchies
- **Rich Metadata**: Add properties and attributes to your content
- **Extensible**: Supports custom block types and inline elements
- **Future-Proof**: Designed for long-term knowledge preservation

#section title="Next Steps"
1. **Explore the Interface**: Familiarize yourself with the sidebar and main content area
2. **Create Your First Document**: Use the file explorer to create new .blox files
3. **Organize with Collections**: Group related files using the collections feature
4. **Customize Settings**: Adjust the appearance and behavior to your preferences

#section title="Tips"
- Use `#h1`, `#h2`, `#h3` for headings
- Create lists with `#list type=unordered` or `#list type=ordered`
- Add code blocks with `#code lang=rust`
- Reference other documents with `{{@document-name}}`

Happy writing with Loom! 🚀''',
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
