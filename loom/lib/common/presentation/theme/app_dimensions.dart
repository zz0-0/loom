import 'package:flutter/material.dart';

/// Centralized dimension constants for consistent sizing across the app
/// Similar to AppSpacing, this provides standardized dimensions for layouts and components
class AppDimensions {
  // Layout dimensions (matching VSCode-inspired values from app_theme.dart)
  static const double sidebarWidth = 240;
  static const double sidebarCollapsedWidth = 48;
  static const double topBarHeight = 35;
  static const double bottomBarHeight = 24;
  static const double sidePanelWidth = 300;
  static const double tabBarHeight = 35;

  // Component dimensions
  static const double windowControlsWidth = 100;
  static const double searchBarWidth = 300;
  static const double searchBarHeight = 22;
  static const double titleBarWidth = 150;
  static const double menuMinWidth = 200;

  // Icon sizes
  static const double iconTiny = 10;
  static const double iconSmall = 12;
  static const double iconMedium = 14;
  static const double iconLarge = 16;
  static const double iconXLarge = 18;
  static const double iconXXLarge = 20;
  static const double iconXXXLarge = 24;
  static const double iconHuge = 32;
  static const double iconMassive = 48;

  // Button dimensions
  static const double buttonMinWidth = 24;
  static const double buttonMinHeight = 24;
  static const double buttonSplashRadius = 12;

  // Editor dimensions
  static const double lineNumbersWidth = 80;
  static const double lineNumbersMinWidth = 30;
  static const double minimapWidth = 120;
  static const double minimapLineHeight = 2;
  static const int minimapMaxLines = 1000;

  // Tab dimensions
  static const double tabBaseWidth = 120;
  static const double tabMaxWidth = 200;
  static const double tabCharWidth = 8;
  static const double tabIconWidth = 24;
  static const double tabCloseButtonWidth = 20;
  static const double tabPadding = 24;
  static const double tabDropdownWidth = 40;

  // List and tree dimensions
  static const double listItemHeight = 24;
  static const double treeItemHeight = 20;
  static const double listIndentWidth = 20;

  // Dialog and overlay dimensions
  static const double dialogMinWidth = 300;
  static const double dialogMaxWidth = 600;
  static const double tooltipMaxWidth = 200;

  // Animation scales
  static const double scaleHover = 1.02;
  static const double scalePressed = 0.98;
  static const double scaleFocus = 1.01;

  // Opacity values
  static const double opacityHover = 0.8;
  static const double opacityDisabled = 0.5;
  static const double opacityFocus = 0.9;

  // Border dimensions
  static const double borderWidthThin = 1;
  static const double borderWidthMedium = 2;
  static const double borderWidthThick = 4;

  // Shadow elevations
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationMedium = 2;
  static const double elevationHigh = 4;
  static const double elevationVeryHigh = 8;

  // Size constraints
  static const Size iconButtonSize = Size(buttonMinWidth, buttonMinHeight);
  static const Size minimapSize = Size(minimapWidth, double.infinity);

  // Utility methods
  static double getScaledDimension(double baseDimension, double scale) {
    return baseDimension * scale;
  }

  static double getTabWidth(
    String title, {
    bool hasIcon = false,
    bool hasCloseButton = false,
  }) {
    var width = tabBaseWidth;
    width += title.length * tabCharWidth;

    if (hasIcon) {
      width += tabIconWidth;
    }

    if (hasCloseButton) {
      width += tabCloseButtonWidth;
    }

    return width + tabPadding;
  }

  static double getListItemIndent(int level) {
    return level * listIndentWidth;
  }

  // Responsive breakpoints (for future use)
  static const double breakpointSmall = 640;
  static const double breakpointMedium = 768;
  static const double breakpointLarge = 1024;
  static const double breakpointXLarge = 1280;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointSmall;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointMedium;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointLarge;
  }
}
