import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// General settings page
class GeneralSettingsPage extends ConsumerWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.general,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.generalDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
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
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        _SettingsItem(
          title: localizations.autoSave,
          subtitle: localizations.autoSaveDescription,
          trailing: Switch(
            value: generalSettings.autoSave,
            onChanged: (value) {
              ref
                  .read(generalSettingsProvider.notifier)
                  .setAutoSave(value: value);
              ref.read(autoSaveProvider.notifier).isEnabled = value;
            },
          ),
        ),
        if (generalSettings.autoSave) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.smd,
            ),
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
                          ref.read(autoSaveProvider.notifier).interval =
                              value.toInt();
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
                    padding: AppSpacing.paddingTopSm,
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
          title: localizations.confirmOnExit,
          subtitle: localizations.confirmOnExitDescription,
          trailing: Switch(
            value: generalSettings.confirmOnExit,
            onChanged: (value) {
              ref
                  .read(generalSettingsProvider.notifier)
                  .setConfirmOnExit(value: value);
            },
          ),
        ),
        _SettingsItem(
          title: localizations.language,
          subtitle: localizations.languageDescription,
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: generalSettings.followSystemLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(generalSettingsProvider.notifier)
                            .setFollowSystemLanguage(value: value);
                      }
                    },
                  ),
                  Text(localizations.followSystemLanguage),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: generalSettings.followSystemLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(generalSettingsProvider.notifier)
                            .setFollowSystemLanguage(value: value);
                      }
                    },
                  ),
                  Text(localizations.manualLanguageSelection),
                ],
              ),
              if (!generalSettings.followSystemLanguage) ...[
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: generalSettings.language,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(generalSettingsProvider.notifier)
                          .setLanguage(value);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(localizations.english),
                    ),
                    DropdownMenuItem(
                      value: 'es',
                      child: Text(localizations.spanish),
                    ),
                    DropdownMenuItem(
                      value: 'fr',
                      child: Text(localizations.french),
                    ),
                    DropdownMenuItem(
                      value: 'de',
                      child: Text(localizations.german),
                    ),
                    DropdownMenuItem(
                      value: 'zh',
                      child: Text(localizations.chinese),
                    ),
                    DropdownMenuItem(
                      value: 'ja',
                      child: Text(localizations.japanese),
                    ),
                    DropdownMenuItem(
                      value: 'ko',
                      child: Text(localizations.korean),
                    ),
                  ],
                ),
              ],
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
          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
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
