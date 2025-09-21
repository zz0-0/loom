import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Close button settings widget
class CloseButtonSettingsWidget extends ConsumerWidget {
  const CloseButtonSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(closeButtonSettingsProvider);
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.closeButtonPositions,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          localizations.closeButtonPositionsDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),

        // Quick set all options
        _SettingsSection(
          title: localizations.quickSettings,
          subtitle: localizations.quickSettingsDescription,
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickSetButton(
                    title: localizations.auto,
                    subtitle: localizations.autoDescription,
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
                    title: localizations.allLeft,
                    subtitle: localizations.allLeftDescription,
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
                    title: localizations.allRight,
                    subtitle: localizations.allRightDescription,
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
          title: localizations.individualSettings,
          subtitle: localizations.individualSettingsDescription,
          children: [
            _CloseButtonPositionSetting(
              title: localizations.tabCloseButtons,
              subtitle: localizations.tabCloseButtonsDescription,
              currentPosition: settings.tabClosePosition,
              effectivePosition: settings.effectiveTabPosition,
              localizations: localizations,
              onChanged: (position) {
                ref
                    .read(closeButtonSettingsProvider.notifier)
                    .setTabClosePosition(position);
              },
            ),
            const SizedBox(height: 16),
            _CloseButtonPositionSetting(
              title: localizations.panelCloseButtons,
              subtitle: localizations.panelCloseButtonsDescription,
              currentPosition: settings.panelClosePosition,
              effectivePosition: settings.effectivePanelPosition,
              localizations: localizations,
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
    required this.localizations,
  });

  final String title;
  final String subtitle;
  final CloseButtonPosition currentPosition;
  final CloseButtonPosition effectivePosition;
  final ValueChanged<CloseButtonPosition> onChanged;
  final AppLocalizations localizations;

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
            '$subtitle (${localizations.currently}: ${_getPositionDisplayName(effectivePosition)})',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<CloseButtonPosition>(
            segments: [
              ButtonSegment<CloseButtonPosition>(
                value: CloseButtonPosition.auto,
                label: Text(localizations.auto),
                icon: const Icon(Icons.auto_awesome, size: 16),
              ),
              ButtonSegment<CloseButtonPosition>(
                value: CloseButtonPosition.left,
                label: Text(localizations.left),
                icon: const Icon(Icons.chevron_left, size: 16),
              ),
              ButtonSegment<CloseButtonPosition>(
                value: CloseButtonPosition.right,
                label: Text(localizations.right),
                icon: const Icon(Icons.chevron_right, size: 16),
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
        return localizations.left;
      case CloseButtonPosition.right:
        return localizations.right;
      case CloseButtonPosition.auto:
        return localizations.auto;
    }
  }
}
