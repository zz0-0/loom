import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Appearance settings page
class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize the visual appearance of Loom',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ThemeSettings(),
                  const SizedBox(height: 32),
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
        const SizedBox(height: 16),
        _SettingsItem(
          title: 'Compact Mode',
          subtitle: 'Use smaller UI elements and reduced spacing',
          trailing: Switch(
            value: appearanceSettings.compactMode,
            onChanged: (value) {
              ref
                  .read(appearanceSettingsProvider.notifier)
                  .setCompactMode(value);
            },
          ),
        ),
        _SettingsItem(
          title: 'Show Icons in Menu',
          subtitle: 'Display icons next to menu items',
          trailing: Switch(
            value: true, // TODO(user): Add to appearance settings
            onChanged: (value) {
              // TODO(user): Implement menu icons toggle
            },
          ),
        ),
        _SettingsItem(
          title: 'Animation Speed',
          subtitle: 'Speed of UI animations and transitions',
          trailing: DropdownButton<String>(
            value: 'Normal',
            onChanged: (value) {
              // TODO(user): Implement animation speed
            },
            items: const [
              DropdownMenuItem(
                value: 'Slow',
                child: Text('Slow'),
              ),
              DropdownMenuItem(
                value: 'Normal',
                child: Text('Normal'),
              ),
              DropdownMenuItem(
                value: 'Fast',
                child: Text('Fast'),
              ),
              DropdownMenuItem(
                value: 'Disabled',
                child: Text('Disabled'),
              ),
            ],
          ),
        ),
        _SettingsItem(
          title: 'Sidebar Transparency',
          subtitle: 'Make sidebar background semi-transparent',
          trailing: Switch(
            value: false, // TODO(user): Add to appearance settings
            onChanged: (value) {
              // TODO(user): Implement sidebar transparency
            },
          ),
        ),
        _SettingsItem(
          title: 'Font Size',
          subtitle: 'Overall application font size',
          trailing: DropdownButton<String>(
            value: 'Medium',
            onChanged: (value) {
              // TODO(user): Implement font size
            },
            items: const [
              DropdownMenuItem(
                value: 'Small',
                child: Text('Small'),
              ),
              DropdownMenuItem(
                value: 'Medium',
                child: Text('Medium'),
              ),
              DropdownMenuItem(
                value: 'Large',
                child: Text('Large'),
              ),
              DropdownMenuItem(
                value: 'Extra Large',
                child: Text('Extra Large'),
              ),
            ],
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
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 4),
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
