import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Search sidebar item that opens search in the side panel
class SearchSidebarItem implements SidebarItem {
  @override
  String get id => 'search';

  @override
  IconData get icon => Icons.search;

  @override
  String? get tooltip => 'Search';

  @override
  VoidCallback? get onPressed => null; // Use default panel behavior

  @override
  Widget? buildPanel(BuildContext context) {
    return const SearchPanel();
  }
}

/// Search panel that appears in the side panel
class SearchPanel extends ConsumerWidget {
  const SearchPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          // Search input field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search files and content...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onSubmitted: (query) {
              // TODO(user): Implement search functionality
            },
          ),
          const SizedBox(height: 16),
          // Quick search options
          _SearchOption(
            icon: Icons.file_present,
            title: 'Files',
            subtitle: 'Search in file names',
            onTap: () {
              // TODO(user): Implement file search
            },
          ),
          const SizedBox(height: 8),
          _SearchOption(
            icon: Icons.text_fields,
            title: 'Content',
            subtitle: 'Search in file content',
            onTap: () {
              // TODO(user): Implement content search
            },
          ),
          const SizedBox(height: 8),
          _SearchOption(
            icon: Icons.code,
            title: 'Symbols',
            subtitle: 'Search for functions, classes',
            onTap: () {
              // TODO(user): Implement symbol search
            },
          ),
        ],
      ),
    );
  }
}

class _SearchOption extends StatelessWidget {
  const _SearchOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Registration function for the search feature
class SearchFeatureRegistration {
  static void register() {
    UIRegistry().registerSidebarItem(SearchSidebarItem());
  }
}
