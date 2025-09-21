import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Window controls settings widget
class WindowControlsSettingsWidget extends ConsumerWidget {
  const WindowControlsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(windowControlsSettingsProvider);
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.windowControls,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _SettingsItem(
          title: localizations.showWindowControls,
          subtitle: localizations.showWindowControlsDescription,
          trailing: Switch(
            value: settings.showControls,
            onChanged: (value) {
              ref
                  .read(windowControlsSettingsProvider.notifier)
                  .setShowControls(show: value);
            },
          ),
        ),
        _SettingsItem(
          title: localizations.controlsPlacement,
          subtitle: localizations.controlsPlacementDescription,
          trailing: DropdownButton<WindowControlsPlacement>(
            value: settings.placement,
            onChanged: (placement) {
              if (placement != null) {
                ref
                    .read(windowControlsSettingsProvider.notifier)
                    .setPlacement(placement);
              }
            },
            items: [
              DropdownMenuItem(
                value: WindowControlsPlacement.auto,
                child: Text(localizations.auto),
              ),
              DropdownMenuItem(
                value: WindowControlsPlacement.left,
                child: Text(localizations.left),
              ),
              DropdownMenuItem(
                value: WindowControlsPlacement.right,
                child: Text(localizations.right),
              ),
            ],
          ),
        ),
        _SettingsItem(
          title: localizations.controlsOrder,
          subtitle: localizations.controlsOrderDescription,
          trailing: DropdownButton<WindowControlsOrder>(
            value: settings.order,
            onChanged: (order) {
              if (order != null) {
                ref
                    .read(windowControlsSettingsProvider.notifier)
                    .setOrder(order);
              }
            },
            items: [
              DropdownMenuItem(
                value: WindowControlsOrder.standard,
                child: Text(localizations.minimizeMaximizeClose),
              ),
              DropdownMenuItem(
                value: WindowControlsOrder.macOS,
                child: Text(localizations.closeMinimizeMaximize),
              ),
              DropdownMenuItem(
                value: WindowControlsOrder.reverse,
                child: Text(localizations.closeMaximizeMinimize),
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
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.smd,
            horizontal: AppSpacing.md,
          ),
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
