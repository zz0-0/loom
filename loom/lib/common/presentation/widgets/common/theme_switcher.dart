import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Theme switcher widget that can be embedded in settings
class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(customThemeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // System theme options
        _ThemeOption(
          title: 'System Default',
          subtitle: 'Adapts to system theme',
          icon: Icons.brightness_auto,
          isSelected: currentTheme.name == 'System Default',
          onTap: () => ref
              .read(customThemeProvider.notifier)
              .setTheme(BuiltInThemes.systemDefault),
        ),

        _ThemeOption(
          title: 'Default Light',
          subtitle: 'Light theme',
          icon: Icons.wb_sunny,
          isSelected: currentTheme.name == 'Default Light',
          onTap: () => ref
              .read(customThemeProvider.notifier)
              .setTheme(BuiltInThemes.defaultLight),
        ),

        _ThemeOption(
          title: 'Default Dark',
          subtitle: 'Dark theme',
          icon: Icons.nightlight_round,
          isSelected: currentTheme.name == 'Default Dark',
          onTap: () => ref
              .read(customThemeProvider.notifier)
              .setTheme(BuiltInThemes.defaultDark),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: AppSpacing.paddingMd,
          margin: AppSpacing.marginBottomSm,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : null,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
