import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// Extensible content area that displays content from registered providers
class ExtensibleContentArea extends ConsumerWidget {
  const ExtensibleContentArea({
    super.key,
    this.contentId,
  });

  final String? contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final registry = UIRegistry();
    final tabState = ref.watch(tabProvider);

    // Use active tab content if available, otherwise fall back to contentId
    final activeTabId = tabState.activeTab?.id;
    final displayContentId = activeTabId ?? contentId;

    // Try to find a content provider that can handle the current content
    final contentProvider = registry.getContentProvider(displayContentId);

    if (contentProvider != null && tabState.hasAnyTabs) {
      return Column(
        children: [
          // Tab bar (replaces the old header with close button)
          const ContentTabBar(),

          // Content area
          Expanded(
            child: contentProvider.build(context),
          ),
        ],
      );
    } else if (contentProvider != null) {
      // Legacy single content mode (for backward compatibility)
      return Column(
        children: [
          // Content header with close button (if content is open)
          if (displayContentId != null)
            Container(
              height: 35,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: AppSpacing.paddingHorizontalMd,
                      child: Text(
                        _getContentTitle(displayContentId),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () {
                      ref.read(uiStateProvider.notifier).closeFile();
                    },
                    splashRadius: 12,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

          // Content area
          Expanded(
            child: contentProvider.build(context),
          ),
        ],
      );
    }

    // Default empty state
    return _buildEmptyState(context, theme);
  }

  String _getContentTitle(String contentId) {
    switch (contentId) {
      case 'settings':
        return 'Settings';
      default:
        return contentId.split('/').last; // Show filename for file paths
    }
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Loom',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This is the main content area',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Content providers can register themselves to display content here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Getting Started',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Register sidebar items using UIRegistry.registerSidebarItem()',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '• Register content providers using UIRegistry.registerContentProvider()',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '• Build your features in the features/ folder',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
