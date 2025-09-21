import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Interface settings page
class InterfaceSettingsPage extends ConsumerWidget {
  const InterfaceSettingsPage({super.key});

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
            localizations.interface,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.interfaceDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  WindowControlsSettingsWidget(),
                  SizedBox(height: 32),
                  Divider(),
                  SizedBox(height: 32),
                  CloseButtonSettingsWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
