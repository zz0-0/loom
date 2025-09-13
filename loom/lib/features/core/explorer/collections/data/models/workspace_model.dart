import 'package:loom/features/core/explorer/index.dart';

/// Data model for Workspace with JSON serialization
class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.name,
    required super.rootPath,
    super.metadata,
    super.fileTree = const [],
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      name: json['name'] as String,
      rootPath: json['rootPath'] as String,
      metadata: json['metadata'] != null
          ? FolderMetadataModel.fromJson(
              json['metadata'] as Map<String, dynamic>,
            )
          : null,
      fileTree: (json['fileTree'] as List<dynamic>? ?? [])
          .map(
            (node) => FileTreeNodeModel.fromJson(node as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rootPath': rootPath,
      'metadata': (metadata as FolderMetadataModel?)?.toJson(),
      'fileTree':
          fileTree.map((node) => (node as FileTreeNodeModel).toJson()).toList(),
    };
  }
}
