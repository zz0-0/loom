import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/app/app.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/plugins/core/plugin_manager.dart';
import 'package:loom/src/rust/frb_generated.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hasDisplay = !Platform.isLinux ||
      Platform.environment['DISPLAY'] != null ||
      Platform.environment['WAYLAND_DISPLAY'] != null;

  if (hasDisplay) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1200, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Initialize Rust bridge
  await RustLib.init();

  // Initialize plugin system v2.0
  await PluginManager.instance.initialize(
    pluginsDirectory: 'lib/plugins/plugins',
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedSettingsRepositoryProvider.overrideWith((ref) {
          final settingsRepo = ref.watch(workspaceSettingsRepositoryProvider);
          return ExplorerSharedSettingsRepository(settingsRepo);
        }),
      ],
      child: const LoomApp(),
    ),
  );
}
