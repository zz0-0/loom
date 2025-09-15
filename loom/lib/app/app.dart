import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/plugin_system/index.dart';
import 'package:loom/features/core/settings/index.dart';

class LoomApp extends ConsumerWidget {
  const LoomApp({required this.pluginBootstrapper, super.key});

  final PluginBootstrapper pluginBootstrapper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = ref.watch(customThemeProvider);
    final fontSettings = ref.watch(fontSettingsProvider);

    // Get system brightness for system themes - use platformDispatcher as fallback
    final systemBrightness = MediaQuery.maybeOf(context)?.platformBrightness ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    // Check if this is a system theme
    final isSystemTheme = BuiltInThemes.isSystemTheme(customTheme);

    final theme = customTheme
        .copyWith(
          fontFamily: fontSettings.fontFamily,
          fontSize: fontSettings.fontSize,
        )
        .toThemeData(isSystemTheme ? systemBrightness : null);

    return MaterialApp(
      title: 'Loom - Knowledge Base',
      theme: theme,
      home: AdaptiveMainLayout(pluginBootstrapper: pluginBootstrapper),
      debugShowCheckedModeBanner: false,
    );
  }
}
