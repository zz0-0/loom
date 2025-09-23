import 'package:flutter/material.dart';

/// Syntax highlighter for Blox markup language
class BloxSyntaxHighlighter extends TextEditingController {
  BloxSyntaxHighlighter({super.text});

  /// Colors for different syntax elements
  BloxSyntaxColors? _colors;

  void updateTheme(ThemeData theme) {
    _colors = BloxSyntaxColors.fromTheme(theme);
  }

  BloxSyntaxColors get colors => _colors ?? BloxSyntaxColors.defaultColors();

  List<TextSpan> _highlightLine(String line) {
    final spans = <TextSpan>[];

    // Empty line
    if (line.trim().isEmpty) {
      spans.add(TextSpan(text: line, style: colors.text));
      return spans;
    }

    // Comment line
    if (line.trim().startsWith('//')) {
      spans.add(TextSpan(text: line, style: colors.comment));
      return spans;
    }

    // Block start line
    final blockMatch =
        RegExp(r'^(#{1,6})(\s*)([a-zA-Z][a-zA-Z0-9_-]*)(\s*)(.*?)$')
            .firstMatch(line);
    if (blockMatch != null) {
      final indent = line.substring(0, line.indexOf('#'));
      final hashes = blockMatch.group(1)!;
      final space1 = blockMatch.group(2)!;
      final blockType = blockMatch.group(3)!;
      final space2 = blockMatch.group(4)!;
      final attributes = blockMatch.group(5) ?? '';

      spans
        ..add(TextSpan(text: indent, style: colors.text))
        ..add(TextSpan(text: hashes, style: colors.blockIndicator))
        ..add(TextSpan(text: space1, style: colors.text))
        ..add(TextSpan(text: blockType, style: colors.blockType))
        ..add(TextSpan(text: space2, style: colors.text));

      if (attributes.isNotEmpty) {
        spans.addAll(_highlightAttributes(attributes));
      }

      return spans;
    }

    // Regular content line
    spans.addAll(_highlightInlineElements(line));
    return spans;
  }

  List<TextSpan> _highlightAttributes(String attributes) {
    final spans = <TextSpan>[];
    final attrPattern =
        RegExp(r'(\w+)=(?:"([^"]*)"|([^\s]+))|(?:"([^"]*)"|([^\s"=]+))');

    var lastEnd = 0;

    for (final match in attrPattern.allMatches(attributes)) {
      // Add any text between matches
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: attributes.substring(lastEnd, match.start),
            style: colors.text,
          ),
        );
      }

      if (match.group(1) != null) {
        // Key=value attribute
        final key = match.group(1)!;
        final value = match.group(2) ?? match.group(3) ?? '';

        spans
          ..add(TextSpan(text: key, style: colors.attributeKey))
          ..add(TextSpan(text: '=', style: colors.text));

        if (match.group(2) != null) {
          // Quoted value
          spans
            ..add(TextSpan(text: '"', style: colors.string))
            ..add(TextSpan(text: value, style: colors.string))
            ..add(TextSpan(text: '"', style: colors.string));
        } else {
          // Unquoted value
          spans.add(TextSpan(text: value, style: colors.attributeValue));
        }
      } else {
        // Positional attribute (quoted string)
        final value = match.group(4) ?? match.group(5) ?? '';
        if (match.group(4) != null) {
          // Quoted
          spans
            ..add(TextSpan(text: '"', style: colors.string))
            ..add(TextSpan(text: value, style: colors.string))
            ..add(TextSpan(text: '"', style: colors.string));
        } else {
          // Unquoted
          spans.add(TextSpan(text: value, style: colors.attributeValue));
        }
      }

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < attributes.length) {
      spans.add(
        TextSpan(
          text: attributes.substring(lastEnd),
          style: colors.text,
        ),
      );
    }

    return spans;
  }

  List<TextSpan> _highlightInlineElements(String line) {
    final spans = <TextSpan>[];
    final inlinePattern = RegExp(r'\{\{([^:}]+):([^}]*)\}\}');

    var lastEnd = 0;

    for (final match in inlinePattern.allMatches(line)) {
      // Add text before inline element
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: line.substring(lastEnd, match.start),
            style: colors.text,
          ),
        );
      }

      // Highlight inline element
      final type = match.group(1)!;
      final content = match.group(2) ?? '';

      spans
        ..add(TextSpan(text: '{{', style: colors.inlineBracket))
        ..add(TextSpan(text: type, style: colors.inlineType))
        ..add(TextSpan(text: ':', style: colors.inlineBracket))
        ..add(TextSpan(text: content, style: colors.inlineContent))
        ..add(TextSpan(text: '}}', style: colors.inlineBracket));

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(lastEnd),
          style: colors.text,
        ),
      );
    }

    return spans;
  }

  /// Get highlighted text as a TextSpan
  TextSpan getHighlightedText() {
    final text = super.text;
    if (text.isEmpty) {
      return TextSpan(text: text, style: colors.text);
    }

    final spans = <TextSpan>[];
    final lines = text.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineSpans = _highlightLine(line);
      spans.addAll(lineSpans);

      // Add newline except for last line
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }
}

/// Color scheme for Blox syntax highlighting
class BloxSyntaxColors {
  const BloxSyntaxColors({
    required this.text,
    required this.comment,
    required this.blockIndicator,
    required this.blockType,
    required this.attributeKey,
    required this.attributeValue,
    required this.string,
    required this.inlineBracket,
    required this.inlineType,
    required this.inlineContent,
  });

  factory BloxSyntaxColors.fromTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return BloxSyntaxColors(
      text: TextStyle(
        color: theme.colorScheme.onSurface,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      comment: TextStyle(
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        fontFamily: 'monospace',
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
      blockIndicator: TextStyle(
        color: theme.colorScheme.primary,
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      blockType: TextStyle(
        color: isDark ? Colors.lightBlue[300] : Colors.blue[700],
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      attributeKey: TextStyle(
        color: isDark ? Colors.orange[300] : Colors.orange[800],
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      attributeValue: TextStyle(
        color: isDark ? Colors.green[300] : Colors.green[700],
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      string: TextStyle(
        color: isDark ? Colors.green[300] : Colors.green[700],
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      inlineBracket: TextStyle(
        color: isDark ? Colors.purple[300] : Colors.purple[700],
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      inlineType: TextStyle(
        color: isDark ? Colors.cyan[300] : Colors.cyan[700],
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      inlineContent: TextStyle(
        color: isDark ? Colors.yellow[300] : Colors.amber[800],
        fontFamily: 'monospace',
        fontSize: 14,
      ),
    );
  }

  factory BloxSyntaxColors.defaultColors() {
    return const BloxSyntaxColors(
      text: TextStyle(
        color: Colors.black,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      comment: TextStyle(
        color: Colors.grey,
        fontFamily: 'monospace',
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
      blockIndicator: TextStyle(
        color: Colors.blue,
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      blockType: TextStyle(
        color: Colors.blue,
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      attributeKey: TextStyle(
        color: Colors.orange,
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      attributeValue: TextStyle(
        color: Colors.green,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      string: TextStyle(
        color: Colors.green,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      inlineBracket: TextStyle(
        color: Colors.purple,
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      inlineType: TextStyle(
        color: Colors.cyan,
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      inlineContent: TextStyle(
        color: Colors.amber,
        fontFamily: 'monospace',
        fontSize: 14,
      ),
    );
  }

  final TextStyle text;
  final TextStyle comment;
  final TextStyle blockIndicator;
  final TextStyle blockType;
  final TextStyle attributeKey;
  final TextStyle attributeValue;
  final TextStyle string;
  final TextStyle inlineBracket;
  final TextStyle inlineType;
  final TextStyle inlineContent;
}
