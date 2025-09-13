/// File/document reference - platform agnostic
class DocumentReference {
  const DocumentReference({
    required this.id,
    required this.path,
    required this.title,
    required this.lastModified,
    this.subtitle,
    this.isModified = false,
    this.iconName,
  });
  final String id;
  final String path;
  final String title;
  final String? subtitle;
  final DateTime lastModified;
  final bool isModified;
  final String? iconName;
}
