import 'package:loom/features/core/explorer/collections/domain/entities/project_file.dart';

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
