import 'package:flutter_test/flutter_test.dart';
import 'package:loom/features/export/domain/entities/export_entities.dart';

void main() {
  group('Export Entities Tests', () {
    test('ExportFormat enum should have correct values', () {
      expect(ExportFormat.pdf, equals(ExportFormat.pdf));
      expect(ExportFormat.html, equals(ExportFormat.html));
      expect(ExportFormat.markdown, equals(ExportFormat.markdown));
      expect(ExportFormat.plainText, equals(ExportFormat.plainText));
    });

    test('ExportFormat displayName should return correct names', () {
      expect(ExportFormat.pdf.displayName, equals('PDF'));
      expect(ExportFormat.html.displayName, equals('HTML'));
      expect(ExportFormat.markdown.displayName, equals('Markdown'));
      expect(ExportFormat.plainText.displayName, equals('Plain Text'));
    });

    test('ExportOptions should initialize with default values', () {
      const options = ExportOptions();

      expect(options.format, equals(ExportFormat.pdf));
      expect(options.includeLineNumbers, isTrue);
      expect(options.includeSyntaxHighlighting, isTrue);
      expect(options.pageSize, equals('A4'));
      expect(options.orientation, equals('portrait'));
      expect(options.fontSize, equals(12));
      expect(options.fontFamily, equals('monospace'));
    });

    test('ExportOptions should support custom values', () {
      const options = ExportOptions(
        format: ExportFormat.markdown,
        includeLineNumbers: false,
        includeSyntaxHighlighting: false,
        pageSize: 'Letter',
        orientation: 'landscape',
        fontSize: 14,
      );

      expect(options.format, equals(ExportFormat.markdown));
      expect(options.includeLineNumbers, isFalse);
      expect(options.includeSyntaxHighlighting, isFalse);
      expect(options.pageSize, equals('Letter'));
      expect(options.orientation, equals('landscape'));
      expect(options.fontSize, equals(14));
    });

    test('ExportOptions copyWith should work correctly', () {
      const original = ExportOptions();
      final copied = original.copyWith(
        includeLineNumbers: false,
        fontSize: 16,
      );

      expect(copied.includeLineNumbers, isFalse);
      expect(copied.fontSize, equals(16));
      expect(copied.format, equals(original.format)); // unchanged
    });

    test('ExportRequest should store content and options', () {
      const content = 'Test content';
      const fileName = 'test.txt';
      const options = ExportOptions();

      const request = ExportRequest(
        content: content,
        fileName: fileName,
        options: options,
      );

      expect(request.content, equals(content));
      expect(request.fileName, equals(fileName));
      expect(request.options.includeLineNumbers, isTrue);
    });

    test('ExportResult should store success and failure states', () {
      // Success result
      const successResult = ExportResult(
        success: true,
        filePath: '/path/to/file.md',
      );

      expect(successResult.success, isTrue);
      expect(successResult.filePath, equals('/path/to/file.md'));
      expect(successResult.errorMessage, isNull);

      // Failure result
      const failureResult = ExportResult(
        success: false,
        filePath: '',
        errorMessage: 'Export failed',
      );

      expect(failureResult.success, isFalse);
      expect(failureResult.filePath, equals(''));
      expect(failureResult.errorMessage, equals('Export failed'));
    });
  });
}
