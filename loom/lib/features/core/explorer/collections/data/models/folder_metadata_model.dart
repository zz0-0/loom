import 'package:loom/features/core/explorer/index.dart';

/// Data model for FolderMetadata with JSON serialization
class FolderMetadataModel extends FolderMetadata {
  const FolderMetadataModel({
    super.version = '1.0',
    super.schemaVersion = '2023.1',
    super.collections = const {},
    super.fileSystemExplorerState = const FileSystemExplorerState(),
    super.session = const SessionState(),
    super.migrationHistory = const [],
  });

  factory FolderMetadataModel.fromJson(Map<String, dynamic> json) {
    return FolderMetadataModel(
      version: json['version'] as String? ?? '1.0',
      schemaVersion: json['schemaVersion'] as String? ?? '2023.1',
      collections: _validateCollections(
        (json['collections'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
      fileSystemExplorerState: json['fileSystemExplorerState'] != null
          ? FileSystemExplorerStateModel.fromJson(
              json['fileSystemExplorerState'] as Map<String, dynamic>,
            )
          : const FileSystemExplorerState(),
      session: json['session'] != null
          ? SessionStateModel.fromJson(json['session'] as Map<String, dynamic>)
          : const SessionState(),
      migrationHistory:
          List<String>.from(json['migrationHistory'] as List? ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'schemaVersion': schemaVersion,
      'collections': collections,
      'fileSystemExplorerState':
          (fileSystemExplorerState as FileSystemExplorerStateModel).toJson(),
      'session': (session as SessionStateModel).toJson(),
      'migrationHistory': migrationHistory,
    };
  }

  static Map<String, List<String>> _validateCollections(
    Map<String, List<String>> collections,
  ) {
    // Ensure collection names are reasonable and file paths are valid
    final validated = <String, List<String>>{};

    for (final entry in collections.entries) {
      final collectionName = entry.key.trim();
      if (collectionName.isEmpty || collectionName.length > 100) continue;

      final validFiles = entry.value.where((path) {
        // Basic path validation - ensure it's a reasonable file path
        return path.isNotEmpty &&
            path.length < 500 &&
            !path.contains('..') && // Prevent directory traversal
            (path.contains('/') ||
                path.contains(r'\')); // Must look like a path
      }).toList();

      if (validFiles.isNotEmpty) {
        validated[collectionName] = validFiles;
      }
    }

    return validated;
  }

  FolderMetadata toDomain() => this;
}
