import 'package:flutter/material.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// UI model for folder template with icon
class FolderTemplateModel extends FolderTemplate {
  const FolderTemplateModel({
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
  FolderTemplate toDomain() => FolderTemplate(
        id: id,
        name: name,
        description: description,
        files: files,
        folders: folders,
      );
}

/// Available folder templates
class FolderTemplates {
  static const List<FolderTemplateModel> templates = [
    FolderTemplateModel(
      id: 'empty',
      name: 'Empty Folder',
      description: 'Start with a blank slate',
      icon: LucideIcons.file,
      files: [
        FolderFile(
          path: 'welcome.blox',
          content: '''
#document title="Welcome to Loom"

#section title="Getting Started"
This is your new Loom folder! Loom uses the Blox format for structured documents.

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
  static FolderTemplateModel? getTemplate(String id) {
    try {
      return templates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get templates as domain entities
  static List<FolderTemplate> getDomainTemplates() {
    return templates.map((t) => t.toDomain()).toList();
  }
}
