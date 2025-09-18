import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// Adaptive layout that chooses between desktop and mobile layouts
/// based on platform and screen size
class AdaptiveMainLayout extends ConsumerWidget {
  const AdaptiveMainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldUseMobileUI =
            PlatformUtils.shouldUseMobileNavigation(context);

        if (shouldUseMobileUI) {
          // Mobile/tablet UI: Bottom navigation, drawer, different interaction patterns
          return const MobileLayout();
        } else {
          // Desktop UI: VSCode-like panels, sidebar, etc.
          return const DesktopLayout();
        }
      },
    );
  }
}
