/// Export format enumeration
enum ExportFormat {
  pdf('PDF'),
  html('HTML'),
  markdown('Markdown'),
  plainText('Plain Text');

  const ExportFormat(this.displayName);
  final String displayName;
}
