import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Loom - Knowledge Base',
      theme: theme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: AdaptiveMainLayout(pluginBootstrapper: pluginBootstrapper),
      debugShowCheckedModeBanner: false,
    );
  }
}
