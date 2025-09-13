import 'package:loom/features/core/explorer/index.dart';

/// Data model for FileSystemExplorerState
class FileSystemExplorerStateModel extends FileSystemExplorerState {
  const FileSystemExplorerStateModel({
    super.expandedPaths = const [],
    super.sortedPaths = const {},
  });

  factory FileSystemExplorerStateModel.fromJson(Map<String, dynamic> json) {
    return FileSystemExplorerStateModel(
      expandedPaths: List<String>.from(json['expandedPaths'] as List? ?? []),
      sortedPaths: Map<String, List<String>>.from(
        (json['sortedPaths'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'expandedPaths': expandedPaths,
      'sortedPaths': sortedPaths,
    };
  }
}
