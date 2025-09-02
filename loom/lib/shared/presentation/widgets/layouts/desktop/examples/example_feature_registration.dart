import 'package:flutter/material.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Example demonstrating how features can register UI components
/// This should be called during app initialization
class ExampleFeatureRegistration {
  static void register() {
    final registry = UIRegistry();

    // Example: Register an explorer sidebar item
    registry.registerSidebarItem(_ExampleExplorerItem());

    // Example: Register a search sidebar item
    registry.registerSidebarItem(_ExampleSearchItem());

    // Example: Register a content provider
    registry.registerContentProvider(_ExampleContentProvider());
  }
}

/// Example explorer sidebar item
class _ExampleExplorerItem implements SidebarItem {
  @override
  String get id => 'explorer';

  @override
  IconData get icon => Icons.folder;

  @override
  String? get tooltip => 'Explorer';

  @override
  VoidCallback? get onPressed => null;

  @override
  Widget? buildPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('File Explorer'),
          SizedBox(height: 16),
          Text('This is where file exploration would go'),
          Text('Register your own explorer implementation here'),
        ],
      ),
    );
  }
}

/// Example search sidebar item
class _ExampleSearchItem implements SidebarItem {
  @override
  String get id => 'search';

  @override
  IconData get icon => Icons.search;

  @override
  String? get tooltip => 'Search';

  @override
  VoidCallback? get onPressed => null;

  @override
  Widget? buildPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search'),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search files...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Text('Search results would appear here'),
        ],
      ),
    );
  }
}

/// Example content provider
class _ExampleContentProvider implements ContentProvider {
  @override
  String get id => 'example_content';

  @override
  bool canHandle(String? contentId) {
    return contentId?.startsWith('example:') == true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64),
          SizedBox(height: 16),
          Text('Example Content Provider'),
          SizedBox(height: 8),
          Text('This demonstrates how to register custom content'),
        ],
      ),
    );
  }
}
