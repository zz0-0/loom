import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Appearance settings page
class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appearanceSettings = ref.watch(appearanceSettingsProvider);
    final compactMode = appearanceSettings.compactMode;

    return Container(
      padding:
          AdaptiveConstants.contentPadding(context, compactMode: compactMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Customize the visual appearance of Loom',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: compactMode ? AppSpacing.md : AppSpacing.lg),
          const Divider(),
          SizedBox(height: compactMode ? AppSpacing.md : AppSpacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ThemeSettings(),
                  SizedBox(height: compactMode ? AppSpacing.sm : AppSpacing.md),
                  const Divider(),
                  SizedBox(height: compactMode ? AppSpacing.sm : AppSpacing.md),
                  _AppearanceGeneralSettings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceGeneralSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appearanceSettings = ref.watch(appearanceSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout & Visual',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _SettingsItem(
          title: 'Compact Mode',
          subtitle: 'Use smaller UI elements and reduced spacing',
          trailing: Switch(
            value: appearanceSettings.compactMode,
            onChanged: (value) {
              ref
                  .read(appearanceSettingsProvider.notifier)
                  .setCompactMode(value: value);
            },
          ),
        ),
        _SettingsItem(
          title: 'Show Icons in Menu',
          subtitle: 'Display icons next to menu items',
          trailing: Switch(
            value: appearanceSettings.showMenuIcons,
            onChanged: (value) {
              ref
                  .read(appearanceSettingsProvider.notifier)
                  .setShowMenuIcons(value: value);
            },
          ),
        ),
        _SettingsItem(
          title: 'Animation Speed',
          subtitle: 'Speed of UI animations and transitions',
          trailing: DropdownButton<String>(
            value: appearanceSettings.animationSpeed,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(appearanceSettingsProvider.notifier)
                    .setAnimationSpeed(value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'slow',
                child: Text('Slow'),
              ),
              DropdownMenuItem(
                value: 'normal',
                child: Text('Normal'),
              ),
              DropdownMenuItem(
                value: 'fast',
                child: Text('Fast'),
              ),
              DropdownMenuItem(
                value: 'disabled',
                child: Text('Disabled'),
              ),
            ],
          ),
        ),
        _SettingsItem(
          title: 'Sidebar Transparency',
          subtitle: 'Make sidebar background semi-transparent',
          trailing: Switch(
            value: appearanceSettings.sidebarTransparency,
            onChanged: (value) {
              ref
                  .read(appearanceSettingsProvider.notifier)
                  .setSidebarTransparency(value: value);
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: AdaptiveConstants.itemSpacing(
              context), // Settings page doesn't need compact spacing
          margin: AppSpacing.marginBottomSm,
          child: Row(
            children: [
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
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
