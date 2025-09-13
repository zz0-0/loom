class FileSystemExplorerState {
  const FileSystemExplorerState({
    this.expandedPaths = const [],
    this.sortedPaths = const {},
  });

  factory FileSystemExplorerState.fromJson(Map<String, dynamic> json) {
    return FileSystemExplorerState(
      expandedPaths: List<String>.from(json['expandedPaths'] as List? ?? []),
      sortedPaths: (json['sortedPaths'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<String>.from(value as List)),
          ) ??
          {},
    );
  }

  final List<String> expandedPaths;
  final Map<String, List<String>> sortedPaths; // Custom sort for folders

  FileSystemExplorerState copyWith({
    List<String>? expandedPaths,
    Map<String, List<String>>? sortedPaths,
  }) {
    return FileSystemExplorerState(
      expandedPaths: expandedPaths ?? this.expandedPaths,
      sortedPaths: sortedPaths ?? this.sortedPaths,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expandedPaths': expandedPaths,
      'sortedPaths': sortedPaths,
    };
  }
}
