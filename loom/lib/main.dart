import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/app/app.dart';
import 'package:loom/common/data/providers.dart';
import 'package:loom/features/core/explorer/data/adapters/shared_settings_adapter.dart';
import 'package:loom/features/core/explorer/presentation/providers/workspace_provider.dart';
import 'package:loom/features/core/plugin_system/domain/plugin_bootstrapper.dart';
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

  // Initialize plugin system
  final pluginBootstrapper = PluginBootstrapper();

  runApp(
    ProviderScope(
      overrides: [
        sharedSettingsRepositoryProvider.overrideWith((ref) {
          final settingsRepo = ref.watch(workspaceSettingsRepositoryProvider);
          return ExplorerSharedSettingsRepository(settingsRepo);
        }),
      ],
      child: LoomApp(pluginBootstrapper: pluginBootstrapper),
    ),
  );
}
