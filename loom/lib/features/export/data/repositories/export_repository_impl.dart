import 'dart:convert';
import 'dart:io';

import 'package:loom/features/export/domain/entities/export_entities.dart';
import 'package:loom/features/export/domain/repositories/export_repository.dart';
import 'package:path/path.dart' as path;

/// Implementation of export repository
class ExportRepositoryImpl implements ExportRepository {
  @override
  Future<ExportResult> exportContent(ExportRequest request) async {
    try {
      final content = _prepareContent(request);
      final filePath = _generateFilePath(request);

      switch (request.options.format) {
        case ExportFormat.pdf:
          return await _exportToPdf(content, filePath, request.options);
        case ExportFormat.html:
          return await _exportToHtml(content, filePath, request.options);
        case ExportFormat.markdown:
          return await _exportToMarkdown(content, filePath, request.options);
        case ExportFormat.plainText:
          return await _exportToPlainText(content, filePath, request.options);
      }
    } catch (e) {
      return ExportResult(
        success: false,
        filePath: '',
        errorMessage: 'Export failed: $e',
      );
    }
  }

  @override
  List<ExportFormat> getSupportedFormats() {
    return ExportFormat.values;
  }

  @override
  bool isFormatSupported(ExportFormat format) {
    return getSupportedFormats().contains(format);
  }

  @override
  String getFileExtension(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return '.pdf';
      case ExportFormat.html:
        return '.html';
      case ExportFormat.markdown:
        return '.md';
      case ExportFormat.plainText:
        return '.txt';
    }
  }

  String _prepareContent(ExportRequest request) {
    var content = request.content;

    if (request.options.includeLineNumbers) {
      content = _addLineNumbers(content);
    }

    return content;
  }

  String _addLineNumbers(String content) {
    final lines = content.split('\n');
    final buffer = StringBuffer();

    for (var i = 0; i < lines.length; i++) {
      final lineNumber = (i + 1).toString().padLeft(4);
      buffer.writeln('$lineNumber: ${lines[i]}');
    }

    return buffer.toString();
  }

  String _generateFilePath(ExportRequest request) {
    if (request.filePath != null) {
      return request.filePath!;
    }

    final directory = Directory.current.path;
    final baseName = path.basenameWithoutExtension(request.fileName);
    final extension = getFileExtension(request.options.format);

    return path.join(directory, '$baseName$extension');
  }

  Future<ExportResult> _exportToPdf(
    String content,
    String filePath,
    ExportOptions options,
  ) async {
    // For now, export as HTML since we don't have PDF library
    // In a real implementation, you'd use pdf package
    final htmlContent = _generateHtml(content, options);
    final file = File(filePath.replaceAll('.pdf', '.html'));

    await file.writeAsString(htmlContent);

    return ExportResult(
      success: true,
      filePath: file.path,
      fileSize: await file.length(),
    );
  }

  Future<ExportResult> _exportToHtml(
    String content,
    String filePath,
    ExportOptions options,
  ) async {
    final htmlContent = _generateHtml(content, options);
    final file = File(filePath);

    await file.writeAsString(htmlContent);

    return ExportResult(
      success: true,
      filePath: file.path,
      fileSize: await file.length(),
    );
  }

  Future<ExportResult> _exportToMarkdown(
    String content,
    String filePath,
    ExportOptions options,
  ) async {
    final markdownContent = _generateMarkdown(content, options);
    final file = File(filePath);

    await file.writeAsString(markdownContent);

    return ExportResult(
      success: true,
      filePath: file.path,
      fileSize: await file.length(),
    );
  }

  Future<ExportResult> _exportToPlainText(
    String content,
    String filePath,
    ExportOptions options,
  ) async {
    final file = File(filePath);

    await file.writeAsString(content);

    return ExportResult(
      success: true,
      filePath: file.path,
      fileSize: await file.length(),
    );
  }

  String _generateHtml(String content, ExportOptions options) {
    final escapedContent = htmlEscape.convert(content);
    final fontSize = options.fontSize;
    final fontFamily = options.fontFamily;

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Exported Document</title>
    <style>
        body {
            font-family: $fontFamily, monospace;
            font-size: ${fontSize}px;
            line-height: 1.5;
            margin: ${options.margin}px;
            white-space: pre-wrap;
        }
        .header {
            text-align: center;
            border-bottom: 1px solid #ccc;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .footer {
            text-align: center;
            border-top: 1px solid #ccc;
            padding-top: 10px;
            margin-top: 20px;
            font-size: ${fontSize - 2}px;
            color: #666;
        }
    </style>
</head>
<body>
    ${options.includeHeader ? '<div class="header"><h1>${options.headerText.isNotEmpty ? options.headerText : 'Exported Document'}</h1></div>' : ''}
    <div class="content">$escapedContent</div>
    ${options.includeFooter ? '<div class="footer">${options.footerText.isNotEmpty ? options.footerText : 'Generated by Loom'}</div>' : ''}
</body>
</html>
''';
  }

  String _generateMarkdown(String content, ExportOptions options) {
    final lines = content.split('\n');
    final buffer = StringBuffer();

    if (options.includeHeader && options.headerText.isNotEmpty) {
      buffer
        ..writeln('# ${options.headerText}')
        ..writeln();
    }

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (options.includeLineNumbers) {
        buffer.writeln('${i + 1}. $line');
      } else {
        buffer.writeln(line);
      }
    }

    if (options.includeFooter && options.footerText.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('---')
        ..writeln('*${options.footerText}*');
    }

    return buffer.toString();
  }
}
