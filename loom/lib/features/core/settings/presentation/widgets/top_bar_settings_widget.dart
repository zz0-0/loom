import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Top bar settings widget
class TopBarSettingsWidget extends ConsumerWidget {
  const TopBarSettingsWidget({super.key});

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
              ref
                  .read(topBarSettingsProvider.notifier)
                  .setShowTitle(show: value);
            },
          ),
        ),
        if (settings.showTitle) ...[
          Padding(
            padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.smd,),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Application Title',
                hintText: 'Enter custom app title',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.smd,
                  vertical: AppSpacing.sm,
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
              ref
                  .read(topBarSettingsProvider.notifier)
                  .setShowSearch(show: value);
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
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.smd, horizontal: AppSpacing.md,),
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
