import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/plugin_system/index.dart';

class LoomApp extends ConsumerWidget {
  const LoomApp({required this.pluginBootstrapper, super.key});

  final PluginBootstrapper pluginBootstrapper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveTheme(
      light: AppTheme.createLightTheme(),
      dark: AppTheme.createDarkTheme(),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Loom - Knowledge Base',
        theme: theme,
        darkTheme: darkTheme,
        home: AdaptiveMainLayout(pluginBootstrapper: pluginBootstrapper),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
