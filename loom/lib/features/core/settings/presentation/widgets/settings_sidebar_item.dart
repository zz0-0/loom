import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

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
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: AppSpacing.paddingSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main settings option
          _SettingCategory(
            icon: Icons.settings,
            title: localizations.settings,
            subtitle: localizations.allSettings,
            onTap: () {
              ref.read(tabProvider.notifier).openTab(
                    id: 'settings',
                    title: localizations.settings,
                    contentType: 'settings',
                    icon: 'settings',
                  );
            },
          ),

          const Divider(),

          // Settings categories
          _SettingCategory(
            icon: Icons.palette,
            title: localizations.appearance,
            subtitle: localizations.appearanceSubtitle,
            onTap: () {
              ref.read(tabProvider.notifier).openTab(
                    id: 'settings:appearance',
                    title: localizations.appearance,
                    contentType: 'settings',
                    icon: 'settings',
                  );
            },
          ),

          _SettingCategory(
            icon: Icons.tune,
            title: localizations.interface,
            subtitle: localizations.interfaceSubtitle,
            onTap: () {
              ref.read(tabProvider.notifier).openTab(
                    id: 'settings:interface',
                    title: localizations.interface,
                    contentType: 'settings',
                    icon: 'settings',
                  );
            },
          ),

          _SettingCategory(
            icon: Icons.settings,
            title: localizations.general,
            subtitle: localizations.generalSubtitle,
            onTap: () {
              ref.read(tabProvider.notifier).openTab(
                    id: 'settings:general',
                    title: localizations.general,
                    contentType: 'settings',
                    icon: 'settings',
                  );
            },
          ),

          _SettingCategory(
            icon: Icons.info_outline,
            title: localizations.about,
            subtitle: localizations.aboutSubtitle,
            onTap: () {
              ref.read(tabProvider.notifier).openTab(
                    id: 'settings:about',
                    title: localizations.about,
                    contentType: 'settings',
                    icon: 'settings',
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingCategory extends StatelessWidget {
  const _SettingCategory({
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
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
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
