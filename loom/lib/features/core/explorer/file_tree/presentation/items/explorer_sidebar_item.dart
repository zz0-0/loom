import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';

/// Explorer sidebar item that integrates with the UI registry system
class ExplorerSidebarItem implements SidebarItem {
  @override
  String get id => 'explorer';

  @override
  IconData get icon => Icons.folder;

  @override
  String? get tooltip => null; // Handled by ExtensibleSidebar for localization

  @override
  VoidCallback? get onPressed => null; // Use default panel behavior

  @override
  Widget? buildPanel(BuildContext context) {
    return const ExplorerPanel();
  }
}

/// Registration function for the explorer feature
class ExplorerFeatureRegistration {
  static void register() {
    final registry = UIRegistry();
    registry.registerSidebarItem(ExplorerSidebarItem());
  }
}
