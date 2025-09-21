import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// About settings page
class AboutSettingsPage extends ConsumerWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.about,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.aboutDescription,
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
                children: [
                  _SettingsItem(
                    title: localizations.version,
                    subtitle: localizations.currentVersion,
                    onTap: () {
                      _showVersionInfo(context, localizations);
                    },
                  ),
                  _SettingsItem(
                    title: localizations.licenses,
                    subtitle: localizations.viewOpenSourceLicenses,
                    onTap: () {
                      _showLicenses(context, localizations);
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

  void _showVersionInfo(BuildContext context, AppLocalizations localizations) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.loom),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${localizations.version}: ${localizations.currentVersion}'),
            const SizedBox(height: 8),
            Text('${localizations.build}: ${localizations.currentBuild}'),
            const SizedBox(height: 16),
            Text(localizations.loomDescription),
            const SizedBox(height: 16),
            Text(localizations.copyright),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context, AppLocalizations localizations) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.openSourceLicenses),
        content: SizedBox(
          width: 400,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.usesFollowingLibraries,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('• ${localizations.flutterLicense}'),
                Text('• ${localizations.riverpodLicense}'),
                Text('• ${localizations.adaptiveThemeLicense}'),
                Text('• ${localizations.filePickerLicense}'),
                Text('• ${localizations.sharedPreferencesLicense}'),
                const SizedBox(height: 16),
                Text(localizations.fullLicenseTexts),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
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
            ],
          ),
        ),
      ),
    );
  }
}
