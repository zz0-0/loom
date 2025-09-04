import 'package:flutter/material.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Example demonstrating how features can register UI components
/// This should be called during app initialization
class ExampleFeatureRegistration {
  static void register() {
    UIRegistry()
      ..registerSidebarItem(_ExampleExplorerItem())
      ..registerSidebarItem(_ExampleSearchItem())
      ..registerContentProvider(_ExampleContentProvider());
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search files...',
                hintStyle: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Search results would appear here',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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
