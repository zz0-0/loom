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

  // Initialize window manager to remove title bar only when a display is
  // available. In headless/devcontainer environments DISPLAY and
  // WAYLAND_DISPLAY are often not set which causes GTK/FL assertions
  // (e.g. 'FL_IS_VIEW(self)') when plugins try to manipulate the native
  // window. Skip window_manager in that case so the app can run in CI
  // or headless containers.
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
