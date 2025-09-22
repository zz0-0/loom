import 'package:loom/features/core/explorer/collections/domain/entities/file_tree_node.dart';

class Folder {
  Folder({required this.rootPath, this.fileTree = const []});
  final String rootPath;
  final List<FileTreeNode> fileTree;

  Folder copyWith({String? rootPath, List<FileTreeNode>? fileTree}) {
    return Folder(
      rootPath: rootPath ?? this.rootPath,
      fileTree: fileTree ?? this.fileTree,
    );
  }
}
