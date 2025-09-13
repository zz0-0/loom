/// Collection template domain entity
class CollectionTemplate {
  const CollectionTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.filePatterns = const [],
    this.suggestedFiles = const [],
    this.color,
  });

  /// Unique identifier for the template
  final String id;

  /// Display name of the template
  final String name;

  /// Description of what this collection template provides
  final String description;

  /// Icon to display for this template
  final String icon;

  /// File patterns to automatically include (globs)
  final List<String> filePatterns;

  /// Suggested files to include in this collection
  final List<String> suggestedFiles;

  /// Optional color theme for the collection
  final String? color;
}
