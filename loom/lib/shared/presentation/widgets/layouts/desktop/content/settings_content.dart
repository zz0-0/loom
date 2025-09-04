import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/close_button_settings_provider.dart';
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
    // Default to appearance settings when just 'settings' is requested
    return const AppearanceSettingsPage();
  }
}

/// Appearance settings content provider
class AppearanceSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:appearance';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:appearance';
  }

  @override
  Widget build(BuildContext context) {
    return const AppearanceSettingsPage();
  }
}

/// Interface settings content provider
class InterfaceSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:interface';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:interface';
  }

  @override
  Widget build(BuildContext context) {
    return const InterfaceSettingsPage();
  }
}

/// General settings content provider
class GeneralSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:general';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:general';
  }

  @override
  Widget build(BuildContext context) {
    return const GeneralSettingsPage();
  }
}

/// About settings content provider
class AboutSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:about';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:about';
  }

  @override
  Widget build(BuildContext context) {
    return const AboutSettingsPage();
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
                title: 'System',
                icon: Icons.brightness_auto,
                isSelected: currentMode == AdaptiveThemeMode.system,
                onTap: () {
                  ref.read(themeModeProvider.notifier).setSystem();
                  AdaptiveTheme.of(context).setSystem();
                },
              ),
            ),
            const SizedBox(width: 12),
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
          subtitle: 'Order of window control buttons',
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
                child: Text('Minimize, Maximize, Close'),
              ),
              DropdownMenuItem(
                value: WindowControlsOrder.macOS,
                child: Text('Close, Minimize, Maximize'),
              ),
              DropdownMenuItem(
                value: WindowControlsOrder.reverse,
                child: Text('Close, Maximize, Minimize'),
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

class _GeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        _SettingsItem(
          title: 'Startup Behavior',
          subtitle: 'What to show when app starts',
          trailing: DropdownButton<String>(
            value: 'Welcome Screen',
            onChanged: (value) {
              // TODO: Implement startup behavior
            },
            items: const [
              DropdownMenuItem(
                value: 'Welcome Screen',
                child: Text('Welcome Screen'),
              ),
              DropdownMenuItem(
                value: 'Last Workspace',
                child: Text('Last Workspace'),
              ),
              DropdownMenuItem(
                value: 'Empty Workspace',
                child: Text('Empty Workspace'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Individual settings pages for specific categories

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

/// Interface settings page
class InterfaceSettingsPage extends ConsumerWidget {
  const InterfaceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interface',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure window controls and layout options',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WindowControlsSettings(),
                  SizedBox(height: 32),
                  CloseButtonSettings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// General settings page
class GeneralSettingsPage extends ConsumerWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'General preferences and application behavior',
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
                  const TopBarSettings(),
                  const SizedBox(height: 24),
                  _GeneralSettings(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// About settings page
class AboutSettingsPage extends ConsumerWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Information about Loom',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceGeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            value: false,
            onChanged: (value) {
              // TODO: Implement compact mode
            },
          ),
        ),
        _SettingsItem(
          title: 'Show Icons in Menu',
          subtitle: 'Display icons next to menu items',
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // TODO: Implement menu icons toggle
            },
          ),
        ),
        _SettingsItem(
          title: 'Animation Speed',
          subtitle: 'Speed of UI animations and transitions',
          trailing: DropdownButton<String>(
            value: 'Normal',
            onChanged: (value) {
              // TODO: Implement animation speed
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
            value: false,
            onChanged: (value) {
              // TODO: Implement sidebar transparency
            },
          ),
        ),
        _SettingsItem(
          title: 'Font Size',
          subtitle: 'Overall application font size',
          trailing: DropdownButton<String>(
            value: 'Medium',
            onChanged: (value) {
              // TODO: Implement font size
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

/// Close button settings widget
class CloseButtonSettings extends ConsumerWidget {
  const CloseButtonSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(closeButtonSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Close Button Positions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Configure where close buttons appear in tabs and panels',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),

        // Quick set all options
        _SettingsSection(
          title: 'Quick Settings',
          subtitle: 'Set all close buttons at once',
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickSetButton(
                    title: 'Auto',
                    subtitle:
                        'Follow platform default settings for the close button',
                    icon: Icons.auto_awesome,
                    onPressed: () {
                      ref
                          .read(closeButtonSettingsProvider.notifier)
                          .setAllToAuto();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickSetButton(
                    title: 'All Left',
                    subtitle: 'Close buttons and window controls on left',
                    icon: Icons.chevron_left,
                    onPressed: () {
                      ref
                          .read(closeButtonSettingsProvider.notifier)
                          .setAllToLeft();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickSetButton(
                    title: 'All Right',
                    subtitle: 'Close buttons and window controls on right',
                    icon: Icons.chevron_right,
                    onPressed: () {
                      ref
                          .read(closeButtonSettingsProvider.notifier)
                          .setAllToRight();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Individual settings
        _SettingsSection(
          title: 'Individual Settings',
          subtitle: 'Fine-tune each close button position',
          children: [
            _CloseButtonPositionSetting(
              title: 'Tab Close Buttons',
              subtitle: 'Position of close buttons in tabs',
              currentPosition: settings.tabClosePosition,
              effectivePosition: settings.effectiveTabPosition,
              onChanged: (position) {
                ref
                    .read(closeButtonSettingsProvider.notifier)
                    .setTabClosePosition(position);
              },
            ),
            const SizedBox(height: 16),
            _CloseButtonPositionSetting(
              title: 'Panel Close Buttons',
              subtitle: 'Position of close buttons in panels',
              currentPosition: settings.panelClosePosition,
              effectivePosition: settings.effectivePanelPosition,
              onChanged: (position) {
                ref
                    .read(closeButtonSettingsProvider.notifier)
                    .setPanelClosePosition(position);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Settings section with title and children
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

/// Quick set button for setting all close button positions
class _QuickSetButton extends StatelessWidget {
  const _QuickSetButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual close button position setting
class _CloseButtonPositionSetting extends StatelessWidget {
  const _CloseButtonPositionSetting({
    required this.title,
    required this.subtitle,
    required this.currentPosition,
    required this.effectivePosition,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final CloseButtonPosition currentPosition;
  final CloseButtonPosition effectivePosition;
  final ValueChanged<CloseButtonPosition> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$subtitle (Currently: ${_getPositionDisplayName(effectivePosition)})',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<CloseButtonPosition>(
            segments: const [
              ButtonSegment<CloseButtonPosition>(
                value: CloseButtonPosition.auto,
                label: Text('Auto'),
                icon: Icon(Icons.auto_awesome, size: 16),
              ),
              ButtonSegment<CloseButtonPosition>(
                value: CloseButtonPosition.left,
                label: Text('Left'),
                icon: Icon(Icons.chevron_left, size: 16),
              ),
              ButtonSegment<CloseButtonPosition>(
                value: CloseButtonPosition.right,
                label: Text('Right'),
                icon: Icon(Icons.chevron_right, size: 16),
              ),
            ],
            selected: {currentPosition},
            onSelectionChanged: (Set<CloseButtonPosition> selection) {
              if (selection.isNotEmpty) {
                onChanged(selection.first);
              }
            },
          ),
        ],
      ),
    );
  }

  String _getPositionDisplayName(CloseButtonPosition position) {
    switch (position) {
      case CloseButtonPosition.left:
        return 'Left';
      case CloseButtonPosition.right:
        return 'Right';
      case CloseButtonPosition.auto:
        return 'Auto';
    }
  }
}
