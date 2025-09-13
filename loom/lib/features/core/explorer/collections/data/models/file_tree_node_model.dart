import 'package:loom/features/core/explorer/index.dart';

/// Data model for FileTreeNode with JSON serialization
class FileTreeNodeModel extends FileTreeNode {
  const FileTreeNodeModel({
    required super.name,
    required super.path,
    required super.type,
    super.isExpanded = false,
    super.children = const [],
    super.lastModified,
    super.size,
  });

  factory FileTreeNodeModel.fromJson(Map<String, dynamic> json) {
    return FileTreeNodeModel(
      name: json['name'] as String,
      path: json['path'] as String,
      type: FileTreeNodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FileTreeNodeType.file,
      ),
      isExpanded: json['isExpanded'] as bool? ?? false,
      children: (json['children'] as List<dynamic>? ?? [])
          .map(
            (child) =>
                FileTreeNodeModel.fromJson(child as Map<String, dynamic>),
          )
          .toList(),
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : null,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type.name,
      'isExpanded': isExpanded,
      'children': children
          .map((child) => (child as FileTreeNodeModel).toJson())
          .toList(),
      'lastModified': lastModified?.toIso8601String(),
      'size': size,
    };
  }
}
