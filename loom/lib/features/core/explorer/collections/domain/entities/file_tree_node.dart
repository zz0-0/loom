import 'package:loom/features/core/explorer/collections/domain/entities/file_tree_node_type.dart';

/// File tree node domain entity
class FileTreeNode {
  const FileTreeNode({
    required this.name,
    required this.path,
    required this.type,
    this.isExpanded = false,
    this.children = const [],
    this.lastModified,
    this.size,
  });

  final String name;
  final String path;
  final FileTreeNodeType type;
  final bool isExpanded;
  final List<FileTreeNode> children;
  final DateTime? lastModified;
  final int? size;

  FileTreeNode copyWith({
    String? name,
    String? path,
    FileTreeNodeType? type,
    bool? isExpanded,
    List<FileTreeNode>? children,
    DateTime? lastModified,
    int? size,
  }) {
    return FileTreeNode(
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      isExpanded: isExpanded ?? this.isExpanded,
      children: children ?? this.children,
      lastModified: lastModified ?? this.lastModified,
      size: size ?? this.size,
    );
  }
}
