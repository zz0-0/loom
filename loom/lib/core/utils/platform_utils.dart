import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform detection and UI behavior utilities
class PlatformUtils {
  /// Check if running on desktop platforms
  static bool get isDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  /// Check if running on mobile platforms
  static bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Check if running on web
  static bool get isWeb {
    return kIsWeb;
  }

  /// Get the appropriate UI paradigm based on platform and screen size
  static UIParadigm getUIParadigm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    if (kIsWeb) {
      return isSmallScreen ? UIParadigm.mobileLike : UIParadigm.desktopLike;
    }

    if (isDesktop) {
      return isSmallScreen ? UIParadigm.compactDesktop : UIParadigm.desktopLike;
    }

    if (isMobile) {
      return isSmallScreen ? UIParadigm.mobileLike : UIParadigm.tabletLike;
    }

    return UIParadigm.desktopLike;
  }

  /// Check if should use mobile-style navigation
  static bool shouldUseMobileNavigation(BuildContext context) {
    final paradigm = getUIParadigm(context);
    return paradigm == UIParadigm.mobileLike;
  }

  /// Check if should use desktop-style panels
  static bool shouldUseDesktopPanels(BuildContext context) {
    final paradigm = getUIParadigm(context);
    return paradigm == UIParadigm.desktopLike ||
        paradigm == UIParadigm.compactDesktop;
  }
}

/// Different UI paradigms for different screen sizes and platforms
enum UIParadigm {
  /// Full desktop experience (VSCode-like)
  desktopLike,

  /// Desktop but with compact UI
  compactDesktop,

  /// Tablet experience (hybrid approach)
  tabletLike,

  /// Mobile experience (drawer navigation, bottom tabs)
  mobileLike,
}

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double large = 1600;
}

/// UI constants that adapt based on platform
class AdaptiveConstants {
  static double sidebarWidth(BuildContext context) {
    final paradigm = PlatformUtils.getUIParadigm(context);
    switch (paradigm) {
      case UIParadigm.desktopLike:
        return 240.0;
      case UIParadigm.compactDesktop:
        return 200.0;
      case UIParadigm.tabletLike:
        return 280.0;
      case UIParadigm.mobileLike:
        return MediaQuery.of(context).size.width * 0.8;
    }
  }

  static double sidePanelWidth(BuildContext context) {
    final paradigm = PlatformUtils.getUIParadigm(context);
    switch (paradigm) {
      case UIParadigm.desktopLike:
        return 320.0;
      case UIParadigm.compactDesktop:
        return 280.0;
      case UIParadigm.tabletLike:
        return 300.0;
      case UIParadigm.mobileLike:
        return MediaQuery.of(context).size.width;
    }
  }

  static double topBarHeight(BuildContext context) {
    final paradigm = PlatformUtils.getUIParadigm(context);
    switch (paradigm) {
      case UIParadigm.desktopLike:
      case UIParadigm.compactDesktop:
        return 35.0;
      case UIParadigm.tabletLike:
        return 48.0;
      case UIParadigm.mobileLike:
        return 56.0; // Standard AppBar height
    }
  }
}
