class Folder {
  Folder({required this.rootPath, this.fileTree = const []});
  final String rootPath;
  final List<dynamic> fileTree;

  Folder copyWith({String? rootPath, List<dynamic>? fileTree}) {
    return Folder(
      rootPath: rootPath ?? this.rootPath,
      fileTree: fileTree ?? this.fileTree,
    );
  }
}
