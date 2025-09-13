import 'package:loom/features/core/explorer/collections/domain/entities/file_system_explorer_state.dart';
import 'package:loom/features/core/explorer/collections/domain/entities/session_state.dart';

/// Folder-specific metadata
class FolderMetadata {
  const FolderMetadata({
    this.version = '1.0',
    this.schemaVersion = '2023.1',
    this.collections = const {},
    this.fileSystemExplorerState = const FileSystemExplorerState(),
    this.session = const SessionState(),
    this.migrationHistory = const [],
  });

  factory FolderMetadata.fromJson(Map<String, dynamic> json) {
    return FolderMetadata(
      version: json['version'] as String? ?? '1.0',
      schemaVersion: json['schemaVersion'] as String? ?? '2023.1',
      collections: (json['collections'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ) ??
          {},
      fileSystemExplorerState: json['fileSystemExplorerState'] != null
          ? FileSystemExplorerState.fromJson(
              json['fileSystemExplorerState'] as Map<String, dynamic>,
            )
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

  FolderMetadata copyWith({
    String? version,
    String? schemaVersion,
    Map<String, List<String>>? collections,
    FileSystemExplorerState? fileSystemExplorerState,
    SessionState? session,
    List<String>? migrationHistory,
  }) {
    return FolderMetadata(
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
