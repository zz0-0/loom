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
    final theme = ref.watch(currentThemeProvider);

    return MaterialApp(
      title: 'Loom - Knowledge Base',
      theme: theme,
      home: AdaptiveMainLayout(pluginBootstrapper: pluginBootstrapper),
      debugShowCheckedModeBanner: false,
    );
  }
}
