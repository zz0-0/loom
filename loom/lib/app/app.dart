import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/settings/presentation/providers/custom_theme_provider.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/adaptive/adaptive_main_layout.dart';

class LoomApp extends ConsumerWidget {
  const LoomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final currentTheme = ref.watch(currentThemeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return AdaptiveTheme(
      light: currentTheme.brightness == Brightness.light
          ? currentTheme
          : lightTheme,
      dark:
          currentTheme.brightness == Brightness.dark ? currentTheme : darkTheme,
      initial: themeMode,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Loom - Knowledge Base',
        theme: theme,
        darkTheme: darkTheme,
        home: const AdaptiveMainLayout(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
