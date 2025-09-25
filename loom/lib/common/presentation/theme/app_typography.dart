import 'package:flutter/material.dart';

/// Centralized typography constants for consistent text styling across the app
/// Similar to AppSpacing, this provides standardized font sizes and text styles
class AppTypography {
  // Font size scale (based on a 14px base with consistent ratios)
  static const double tiny = 10;
  static const double extraSmall =
      11; // For tight spaces that need slightly larger than tiny
  static const double small = 12;
  static const double body = 14;
  static const double medium = 16;
  static const double large = 18;
  static const double xLarge = 20;
  static const double xxLarge = 24;
  static const double xxxLarge = 28;
  static const double huge = 36;

  // Editor-specific font sizes
  static const double editorBody = body; // 14
  static const double editorCode = 13;
  static const double editorSmall = small; // 12
  static const double editorTiny = tiny; // 10

  // Heading font sizes (matching the scale used in blox_renderer)
  static const double heading1 = huge; // 36
  static const double heading2 = xxxLarge; // 28
  static const double heading3 = xxLarge; // 24
  static const double heading4 = xLarge; // 20
  static const double heading5 = large; // 18
  static const double heading6 = medium; // 16
  static const double heading7 = body; // 14

  // Special content font sizes
  static const double codeBlock = editorCode; // 13
  static const double mathBlock = medium; // 16
  static const double imageCaption = editorSmall; // 12
  static const double footnote = editorSmall * 0.8; // 9.6

  // UI element font sizes
  static const double lineNumbers = editorBody; // 14
  static const double searchResult = editorSmall; // 12
  static const double commandPalette = editorTiny; // 10
  static const double fileTreeItem = editorTiny; // 10
  static const double collectionItem = editorSmall; // 12

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight mediumWeight = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Line heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.6;

  // Letter spacing
  static const double letterSpacingTight = -0.02;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.02;

  // Text styles for common use cases
  static const TextStyle editorTextStyle = TextStyle(
    fontSize: editorBody,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: 'monospace',
  );

  static const TextStyle codeTextStyle = TextStyle(
    fontSize: codeBlock,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: 'monospace',
  );

  static const TextStyle mathTextStyle = TextStyle(
    fontSize: mathBlock,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: 'monospace',
  );

  static const TextStyle lineNumbersTextStyle = TextStyle(
    fontSize: lineNumbers,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: 'monospace',
  );

  static const TextStyle smallTextStyle = TextStyle(
    fontSize: editorSmall,
    fontWeight: regular,
    height: lineHeightNormal,
  );

  static const TextStyle tinyTextStyle = TextStyle(
    fontSize: editorTiny,
    fontWeight: regular,
    height: lineHeightNormal,
  );

  // Heading text styles
  static const TextStyle heading1Style = TextStyle(
    fontSize: heading1,
    fontWeight: bold,
    height: lineHeightTight,
  );

  static const TextStyle heading2Style = TextStyle(
    fontSize: heading2,
    fontWeight: bold,
    height: lineHeightTight,
  );

  static const TextStyle heading3Style = TextStyle(
    fontSize: heading3,
    fontWeight: bold,
    height: lineHeightTight,
  );

  static const TextStyle heading4Style = TextStyle(
    fontSize: heading4,
    fontWeight: bold,
    height: lineHeightTight,
  );

  static const TextStyle heading5Style = TextStyle(
    fontSize: heading5,
    fontWeight: bold,
    height: lineHeightTight,
  );

  static const TextStyle heading6Style = TextStyle(
    fontSize: heading6,
    fontWeight: bold,
    height: lineHeightTight,
  );

  static const TextStyle heading7Style = TextStyle(
    fontSize: heading7,
    fontWeight: bold,
    height: lineHeightTight,
  );

  // Utility methods for creating text styles
  static TextStyle getHeadingStyle(int level) {
    return switch (level) {
      -1 => heading1Style, // Document title
      1 => heading1Style,
      2 => heading2Style,
      3 => heading3Style,
      4 => heading4Style,
      5 => heading5Style,
      6 => heading6Style,
      7 => heading7Style,
      _ => heading7Style,
    };
  }

  static TextStyle getScaledTextStyle(TextStyle baseStyle, double scale) {
    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize! * scale,
    );
  }

  static TextStyle getSubscriptStyle(TextStyle baseStyle) {
    return getScaledTextStyle(baseStyle, 0.8);
  }

  static TextStyle getSuperscriptStyle(TextStyle baseStyle) {
    return getScaledTextStyle(baseStyle, 0.8);
  }

  static TextStyle getFootnoteStyle(TextStyle baseStyle) {
    return getScaledTextStyle(baseStyle, 0.8);
  }
}
