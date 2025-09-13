import 'package:loom/features/core/explorer/collections/domain/entities/file_tree_node.dart';
import 'package:loom/features/core/explorer/collections/domain/entities/folder_metadata.dart';

/// Workspace domain entity
class Workspace {
  const Workspace({
    required this.name,
    required this.rootPath,
    this.metadata,
    this.fileTree = const [],
  });

  final String name;
  final String rootPath;
  final FolderMetadata? metadata;
  final List<FileTreeNode> fileTree;

  Workspace copyWith({
    String? name,
    String? rootPath,
    FolderMetadata? metadata,
    List<FileTreeNode>? fileTree,
  }) {
    return Workspace(
      name: name ?? this.name,
      rootPath: rootPath ?? this.rootPath,
      metadata: metadata ?? this.metadata,
      fileTree: fileTree ?? this.fileTree,
    );
  }
}
