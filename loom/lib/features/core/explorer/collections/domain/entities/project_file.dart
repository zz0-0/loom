/// Project file to be created from template
class ProjectFile {
  const ProjectFile({
    required this.path,
    required this.content,
  });

  /// Relative path where the file should be created
  final String path;

  /// Content of the file
  final String content;
}
