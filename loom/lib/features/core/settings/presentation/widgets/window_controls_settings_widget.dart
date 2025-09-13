import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Window controls settings widget
class WindowControlsSettingsWidget extends ConsumerWidget {
  const WindowControlsSettingsWidget({super.key});

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
                  .setShowControls(show: value);
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
