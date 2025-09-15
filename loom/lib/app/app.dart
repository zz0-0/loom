import 'package:adaptive_theme/adaptive_theme.dart';
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
    final themeMode = ref.watch(themeModeProvider);

    final brightness = switch (themeMode) {
      AdaptiveThemeMode.light => Brightness.light,
      AdaptiveThemeMode.dark => Brightness.dark,
      AdaptiveThemeMode.system => MediaQuery.of(context).platformBrightness,
    };

    final theme = customTheme
        .copyWith(
          fontFamily: fontSettings.fontFamily,
          fontSize: fontSettings.fontSize,
        )
        .toThemeData(brightness);

    return MaterialApp(
      title: 'Loom - Knowledge Base',
      theme: theme,
      home: AdaptiveMainLayout(pluginBootstrapper: pluginBootstrapper),
      debugShowCheckedModeBanner: false,
    );
  }
}
