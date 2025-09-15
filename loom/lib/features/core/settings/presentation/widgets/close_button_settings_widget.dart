import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Close button settings widget
class CloseButtonSettingsWidget extends ConsumerWidget {
  const CloseButtonSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(closeButtonSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Close Button Positions',
          style: theme.textTheme.titleMedium?.copyWith(
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
          padding: AppSpacing.paddingMd,
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
      padding: AppSpacing.paddingMd,
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
