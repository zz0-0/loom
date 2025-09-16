import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';

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
  static double sidebarWidth(BuildContext context, {bool compactMode = false}) {
    final paradigm = PlatformUtils.getUIParadigm(context);
    final baseWidth = switch (paradigm) {
      UIParadigm.desktopLike => compactMode ? 200.0 : 240.0,
      UIParadigm.compactDesktop => 200.0,
      UIParadigm.tabletLike => 280.0,
      UIParadigm.mobileLike => MediaQuery.of(context).size.width * 0.8,
    };
    return baseWidth;
  }

  static double sidePanelWidth(BuildContext context,
      {bool compactMode = false}) {
    final paradigm = PlatformUtils.getUIParadigm(context);
    final baseWidth = switch (paradigm) {
      UIParadigm.desktopLike => compactMode ? 280.0 : 320.0,
      UIParadigm.compactDesktop => 280.0,
      UIParadigm.tabletLike => 300.0,
      UIParadigm.mobileLike => MediaQuery.of(context).size.width,
    };
    return baseWidth;
  }

  static double topBarHeight(BuildContext context, {bool compactMode = false}) {
    final paradigm = PlatformUtils.getUIParadigm(context);
    final baseHeight = switch (paradigm) {
      UIParadigm.desktopLike ||
      UIParadigm.compactDesktop =>
        compactMode ? 30.0 : 35.0,
      UIParadigm.tabletLike => 48.0,
      UIParadigm.mobileLike => 56.0, // Standard AppBar height
    };
    return baseHeight;
  }

  static EdgeInsetsGeometry contentPadding(BuildContext context,
      {bool compactMode = false}) {
    final multiplier = compactMode ? 0.75 : 1.0;
    return EdgeInsets.all(AppSpacing.md * multiplier);
  }

  static EdgeInsetsGeometry itemSpacing(BuildContext context,
      {bool compactMode = false}) {
    final multiplier = compactMode ? 0.75 : 1.0;
    return EdgeInsets.symmetric(
      horizontal: AppSpacing.md * multiplier,
      vertical: AppSpacing.sm * multiplier,
    );
  }
}
