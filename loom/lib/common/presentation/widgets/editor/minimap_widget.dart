import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Minimap widget for displaying a scaled-down view of the file content
class MinimapWidget extends ConsumerWidget {
  const MinimapWidget({
    required this.text,
    required this.scrollPosition,
    required this.maxScrollExtent,
    required this.viewportHeight,
    required this.onScrollToPosition,
    required this.isBloxFile,
    super.key,
    this.width = 120,
    this.maxLines = 1000,
    this.showLineNumbers = false,
  });

  final String text;
  final double scrollPosition;
  final double maxScrollExtent;
  final double viewportHeight;
  final void Function(double position) onScrollToPosition;
  final bool isBloxFile;
  final double width;
  final int maxLines;
  final bool showLineNumbers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          left: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: _buildMinimapContent(context, theme),
    );
  }

  Widget _buildMinimapContent(BuildContext context, ThemeData theme) {
    if (text.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.text_fields,
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
          size: 24,
        ),
      );
    }

    final lines = text.split('\n');

    // Limit lines for performance
    final displayLines =
        lines.length > maxLines ? lines.sublist(0, maxLines) : lines;
    final scaleFactor = max(0.1, width / 200.0); // Scale based on width

    return GestureDetector(
      onTapDown: (details) => _handleMinimapTap(details, displayLines.length),
      child: Stack(
        children: [
          // Minimap content
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: CustomPaint(
              size: Size(width, displayLines.length * 2.0), // 2px per line
              painter: MinimapPainter(
                lines: displayLines,
                scaleFactor: scaleFactor,
                isBloxFile: isBloxFile,
                theme: theme,
              ),
            ),
          ),

          // Viewport indicator
          if (maxScrollExtent > 0)
            Positioned(
              top: _calculateViewportTop(),
              left: 0,
              right: 0,
              child: Container(
                height: _calculateViewportHeight(),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleMinimapTap(TapDownDetails details, int totalLines) {
    final relativeY = details.localPosition.dy;
    final totalHeight = totalLines * 2.0; // 2px per line
    final relativePosition = relativeY / totalHeight;

    // Calculate the target scroll position
    final targetPosition = relativePosition * maxScrollExtent;

    onScrollToPosition(targetPosition);
  }

  double _calculateViewportTop() {
    if (maxScrollExtent == 0) return 0;
    return (scrollPosition / maxScrollExtent) *
        (maxLines * 2.0); // Approximate line height
  }

  double _calculateViewportHeight() {
    if (maxScrollExtent == 0) return 0;
    return (viewportHeight / maxScrollExtent) *
        (maxLines * 2.0); // Approximate line height
  }
}

/// Custom painter for rendering the minimap content
class MinimapPainter extends CustomPainter {
  MinimapPainter({
    required this.lines,
    required this.scaleFactor,
    required this.isBloxFile,
    required this.theme,
  });

  final List<String> lines;
  final double scaleFactor;
  final bool isBloxFile;
  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final y = i * 2.0; // 2px per line

      if (y > size.height) break;

      // Determine line color based on content
      final color = _getLineColor(line);

      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, 2),
        paint,
      );
    }
  }

  Color _getLineColor(String line) {
    if (line.trim().isEmpty) {
      return theme.colorScheme.surfaceContainerHighest.withOpacity(0.1);
    }

    if (line.trim().startsWith('//')) {
      return theme.colorScheme.onSurfaceVariant.withOpacity(0.3);
    }

    if (isBloxFile) {
      // Blox-specific highlighting
      if (line.contains('#')) {
        final hashMatch = RegExp('^#{1,6}').firstMatch(line.trim());
        if (hashMatch != null) {
          return theme.colorScheme.primary.withOpacity(0.6);
        }
      }

      if (line.contains('{{') && line.contains('}}')) {
        return theme.colorScheme.secondary.withOpacity(0.5);
      }

      if (line.contains('```')) {
        return theme.colorScheme.tertiary.withOpacity(0.5);
      }
    } else {
      // Generic syntax highlighting for other files
      if (line.contains('//') || line.contains('#')) {
        return theme.colorScheme.onSurfaceVariant.withOpacity(0.4);
      }

      if (line.contains('function') ||
          line.contains('class') ||
          line.contains('def')) {
        return theme.colorScheme.primary.withOpacity(0.5);
      }

      if (line.contains('import') ||
          line.contains('from') ||
          line.contains('package')) {
        return theme.colorScheme.secondary.withOpacity(0.4);
      }
    }

    return theme.colorScheme.onSurface.withOpacity(0.2);
  }

  @override
  bool shouldRepaint(covariant MinimapPainter oldDelegate) {
    return oldDelegate.lines != lines ||
        oldDelegate.scaleFactor != scaleFactor ||
        oldDelegate.isBloxFile != isBloxFile ||
        oldDelegate.theme != theme;
  }
}
