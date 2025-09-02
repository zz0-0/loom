import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/providers/top_bar_settings_provider.dart';
import 'package:loom/shared/presentation/providers/window_controls_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/window_controls.dart';

/// Settings content provider that displays settings in the main content area
class SettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings';
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsPage();
  }
}

/// Full settings page for the main content area
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Text(
            'Settings',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your Loom experience',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Settings content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance section
                  const _SettingsSection(
                    title: 'Appearance',
                    children: [
                      ThemeSettings(),
                      SizedBox(height: 16),
                      TopBarSettings(),
                      SizedBox(height: 16),
                      WindowControlsSettings(),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // General section
                  _SettingsSection(
                    title: 'General',
                    children: [
                      _SettingsItem(
                        title: 'Auto Save',
                        subtitle: 'Automatically save changes',
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {
                            // TODO: Implement auto save toggle
                          },
                        ),
                      ),
                      _SettingsItem(
                        title: 'Word Wrap',
                        subtitle: 'Wrap long lines in editor',
                        trailing: Switch(
                          value: false,
                          onChanged: (value) {
                            // TODO: Implement word wrap toggle
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // About section
                  _SettingsSection(
                    title: 'About',
                    children: [
                      _SettingsItem(
                        title: 'Version',
                        subtitle: '1.0.0',
                        onTap: () {
                          // TODO: Show version info
                        },
                      ),
                      _SettingsItem(
                        title: 'Licenses',
                        subtitle: 'View open source licenses',
                        onTap: () {
                          // TODO: Show licenses
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Theme settings widget
class ThemeSettings extends ConsumerWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentMode = ref.watch(themeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Theme options in a row layout
        Row(
          children: [
            Expanded(
              child: _ThemeCard(
                title: 'Light',
                icon: Icons.wb_sunny,
                isSelected: currentMode == AdaptiveThemeMode.light,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setLight();
                  AdaptiveTheme.of(context).setLight();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ThemeCard(
                title: 'Dark',
                icon: Icons.nightlight_round,
                isSelected: currentMode == AdaptiveThemeMode.dark,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setDark();
                  AdaptiveTheme.of(context).setDark();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ThemeCard(
                title: 'System',
                icon: Icons.brightness_auto,
                isSelected: currentMode == AdaptiveThemeMode.system,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setSystem();
                  AdaptiveTheme.of(context).setSystem();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Window controls settings widget
class WindowControlsSettings extends ConsumerWidget {
  const WindowControlsSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(windowControlsSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Window Controls',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsItem(
          title: 'Show Window Controls',
          subtitle: 'Display minimize, maximize, and close buttons',
          trailing: Switch(
            value: settings.showControls,
            onChanged: (value) {
              ref
                  .read(windowControlsSettingsProvider.notifier)
                  .setShowControls(value);
            },
          ),
        ),
        _SettingsItem(
          title: 'Controls Placement',
          subtitle: 'Position of window control buttons',
          trailing: DropdownButton<WindowControlsPlacement>(
            value: settings.placement,
            onChanged: (placement) {
              if (placement != null) {
                ref
                    .read(windowControlsSettingsProvider.notifier)
                    .setPlacement(placement);
              }
            },
            items: const [
              DropdownMenuItem(
                value: WindowControlsPlacement.auto,
                child: Text('Auto'),
              ),
              DropdownMenuItem(
                value: WindowControlsPlacement.left,
                child: Text('Left'),
              ),
              DropdownMenuItem(
                value: WindowControlsPlacement.right,
                child: Text('Right'),
              ),
            ],
          ),
        ),
        _SettingsItem(
          title: 'Controls Order',
          subtitle: 'Order of minimize, maximize, and close buttons',
          trailing: DropdownButton<WindowControlsOrder>(
            value: settings.order,
            onChanged: (order) {
              if (order != null) {
                ref
                    .read(windowControlsSettingsProvider.notifier)
                    .setOrder(order);
              }
            },
            items: const [
              DropdownMenuItem(
                value: WindowControlsOrder.standard,
                child: Text('Standard'),
              ),
              DropdownMenuItem(
                value: WindowControlsOrder.macOS,
                child: Text('macOS Style'),
              ),
              DropdownMenuItem(
                value: WindowControlsOrder.reverse,
                child: Text('Reverse'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Top bar settings widget
class TopBarSettings extends ConsumerWidget {
  const TopBarSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(topBarSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Bar',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsItem(
          title: 'Show App Title',
          subtitle: 'Display application name in the top bar',
          trailing: Switch(
            value: settings.showTitle,
            onChanged: (value) {
              ref.read(topBarSettingsProvider.notifier).setShowTitle(value);
            },
          ),
        ),
        if (settings.showTitle) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Application Title',
                hintText: 'Enter custom app title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              controller: TextEditingController(text: settings.title),
              onChanged: (value) {
                ref
                    .read(topBarSettingsProvider.notifier)
                    .setTitle(value.isNotEmpty ? value : 'Loom');
              },
            ),
          ),
        ],
        _SettingsItem(
          title: 'Show Search Bar',
          subtitle: 'Display search functionality in top bar',
          trailing: Switch(
            value: settings.showSearch,
            onChanged: (value) {
              ref.read(topBarSettingsProvider.notifier).setShowSearch(value);
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : null,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
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
