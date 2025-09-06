/// Export domain entities
enum ExportFormat {
  pdf('PDF'),
  html('HTML'),
  markdown('Markdown'),
  plainText('Plain Text');

  const ExportFormat(this.displayName);
  final String displayName;
}

class ExportOptions {
  const ExportOptions({
    this.format = ExportFormat.pdf,
    this.includeLineNumbers = true,
    this.includeSyntaxHighlighting = true,
    this.pageSize = 'A4',
    this.orientation = 'portrait',
    this.fontSize = 12,
    this.fontFamily = 'monospace',
    this.margin = 20,
    this.includeHeader = true,
    this.includeFooter = false,
    this.headerText = '',
    this.footerText = '',
  });

  final ExportFormat format;
  final bool includeLineNumbers;
  final bool includeSyntaxHighlighting;
  final String pageSize;
  final String orientation;
  final int fontSize;
  final String fontFamily;
  final int margin;
  final bool includeHeader;
  final bool includeFooter;
  final String headerText;
  final String footerText;

  ExportOptions copyWith({
    ExportFormat? format,
    bool? includeLineNumbers,
    bool? includeSyntaxHighlighting,
    String? pageSize,
    String? orientation,
    int? fontSize,
    String? fontFamily,
    int? margin,
    bool? includeHeader,
    bool? includeFooter,
    String? headerText,
    String? footerText,
  }) {
    return ExportOptions(
      format: format ?? this.format,
      includeLineNumbers: includeLineNumbers ?? this.includeLineNumbers,
      includeSyntaxHighlighting:
          includeSyntaxHighlighting ?? this.includeSyntaxHighlighting,
      pageSize: pageSize ?? this.pageSize,
      orientation: orientation ?? this.orientation,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      margin: margin ?? this.margin,
      includeHeader: includeHeader ?? this.includeHeader,
      includeFooter: includeFooter ?? this.includeFooter,
      headerText: headerText ?? this.headerText,
      footerText: footerText ?? this.footerText,
    );
  }
}

class ExportResult {
  const ExportResult({
    required this.success,
    required this.filePath,
    this.errorMessage,
    this.fileSize,
  });

  final bool success;
  final String filePath;
  final String? errorMessage;
  final int? fileSize;
}

class ExportRequest {
  const ExportRequest({
    required this.content,
    required this.fileName,
    required this.options,
    this.filePath,
  });

  final String content;
  final String fileName;
  final ExportOptions options;
  final String? filePath;
}
