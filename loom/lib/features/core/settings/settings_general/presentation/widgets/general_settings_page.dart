import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/settings_general/presentation/providers/general_settings_provider.dart';

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

class _GeneralSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalSettings = ref.watch(generalSettingsProvider);
    final autoSaveState = ref.watch(autoSaveProvider);

    return Column(
      children: [
        _SettingsItem(
          title: 'Auto Save',
          subtitle: 'Automatically save changes at regular intervals',
          trailing: Switch(
            value: generalSettings.autoSave,
            onChanged: (value) {
              ref.read(generalSettingsProvider.notifier).setAutoSave(value);
              ref.read(autoSaveProvider.notifier).setEnabled(value);
            },
          ),
        ),
        if (generalSettings.autoSave) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto-save Interval',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: autoSaveState.intervalSeconds.toDouble(),
                        min: 10,
                        max: 300,
                        divisions: 29,
                        label: '${autoSaveState.intervalSeconds}s',
                        onChanged: (value) {
                          ref
                              .read(autoSaveProvider.notifier)
                              .setInterval(value.toInt());
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${autoSaveState.intervalSeconds}s',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                if (autoSaveState.lastSaveTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Last saved: ${_formatLastSaveTime(autoSaveState.lastSaveTime!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        _SettingsItem(
          title: 'Confirm on Exit',
          subtitle: 'Ask for confirmation when closing with unsaved changes',
          trailing: Switch(
            value: generalSettings.confirmOnExit,
            onChanged: (value) {
              ref
                  .read(generalSettingsProvider.notifier)
                  .setConfirmOnExit(value);
            },
          ),
        ),
        _SettingsItem(
          title: 'Language',
          subtitle: 'Application language',
          trailing: DropdownButton<String>(
            value: generalSettings.language,
            onChanged: (value) {
              if (value != null) {
                ref.read(generalSettingsProvider.notifier).setLanguage(value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'es',
                child: Text('Español'),
              ),
              DropdownMenuItem(
                value: 'fr',
                child: Text('Français'),
              ),
              DropdownMenuItem(
                value: 'de',
                child: Text('Deutsch'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatLastSaveTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
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
