import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/app/app.dart';
import 'package:loom/features/explorer/data/adapters/shared_settings_adapter.dart';
import 'package:loom/features/explorer/data/providers.dart';
import 'package:loom/shared/data/providers.dart';
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
