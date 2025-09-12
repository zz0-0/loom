import 'package:flutter/material.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// UI model for project template with icon
class ProjectTemplateModel extends ProjectTemplate {
  const ProjectTemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.files,
    required this.icon,
    super.folders,
  });

  /// Icon to display in the UI
  final IconData icon;

  /// Convert to domain entity
  ProjectTemplate toDomain() => ProjectTemplate(
        id: id,
        name: name,
        description: description,
        files: files,
        folders: folders,
      );
}

/// Available project templates
class ProjectTemplates {
  static const List<ProjectTemplateModel> templates = [
    ProjectTemplateModel(
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
  static ProjectTemplateModel? getTemplate(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get templates as domain entities
  static List<ProjectTemplate> getDomainTemplates() {
    return templates.map((t) => t.toDomain()).toList();
  }
}
