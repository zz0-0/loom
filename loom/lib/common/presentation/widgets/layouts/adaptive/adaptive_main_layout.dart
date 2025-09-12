import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/desktop_layout.dart';
import 'package:loom/common/presentation/widgets/layouts/mobile/mobile_layout.dart';
import 'package:loom/common/utils/platform_utils.dart';
import 'package:loom/features/core/plugin_system/domain/plugin_bootstrapper.dart';

/// Adaptive layout that chooses between desktop and mobile layouts
/// based on platform and screen size
class AdaptiveMainLayout extends ConsumerWidget {
  const AdaptiveMainLayout({required this.pluginBootstrapper, super.key});

  final PluginBootstrapper pluginBootstrapper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldUseMobileUI =
            PlatformUtils.shouldUseMobileNavigation(context);

        if (shouldUseMobileUI) {
          // Mobile/tablet UI: Bottom navigation, drawer, different interaction patterns
          return MobileLayout(pluginBootstrapper: pluginBootstrapper);
        } else {
          // Desktop UI: VSCode-like panels, sidebar, etc.
          return DesktopLayout(pluginBootstrapper: pluginBootstrapper);
        }
      },
    );
  }
}
