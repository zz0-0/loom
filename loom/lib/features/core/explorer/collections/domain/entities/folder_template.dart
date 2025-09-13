import 'package:loom/features/core/explorer/collections/domain/entities/folder_file.dart';

/// Folder template domain entity
class FolderTemplate {
  const FolderTemplate({
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

  /// Description of what this folder template provides
  final String description;

  /// Files to create when using this template
  final List<FolderFile> files;

  /// Folders to create when using this template
  final List<String> folders;
}
