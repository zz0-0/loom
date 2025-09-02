import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Settings sidebar item that opens settings in the main content area
class SettingsSidebarItem implements SidebarItem {
  @override
  String get id => 'settings';

  @override
  IconData get icon => Icons.settings;

  @override
  String? get tooltip => 'Settings';

  @override
  VoidCallback? get onPressed => null; // Use default panel behavior

  @override
  Widget? buildPanel(BuildContext context) {
    return const SettingsQuickPanel();
  }
}

/// Quick settings panel in the sidebar
class SettingsQuickPanel extends ConsumerWidget {
  const SettingsQuickPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Settings',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Quick settings items
          _QuickSettingItem(
            icon: Icons.palette,
            title: 'Appearance',
            subtitle: 'Theme, colors, layout',
            onTap: () {
              // Open settings page in main content
              ref.read(uiStateProvider.notifier).openFile('settings');
            },
          ),

          _QuickSettingItem(
            icon: Icons.tune,
            title: 'Preferences',
            subtitle: 'General settings',
            onTap: () {
              // Open settings page in main content
              ref.read(uiStateProvider.notifier).openFile('settings');
            },
          ),

          const Spacer(),

          // Open full settings button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                // Open full settings in main content area
                ref.read(uiStateProvider.notifier).openFile('settings');
              },
              icon: const Icon(Icons.settings, size: 16),
              label: const Text('All Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSettingItem extends StatelessWidget {
  const _QuickSettingItem({
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
