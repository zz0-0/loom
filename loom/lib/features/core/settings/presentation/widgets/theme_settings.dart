import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Theme settings widget
class ThemeSettings extends ConsumerWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentMode = AdaptiveTheme.of(context).mode;
    final customTheme = ref.watch(customThemeProvider);
    final fontSettings = ref.watch(fontSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Theme mode selection (System/Light/Dark)
        _SettingsSection(
          title: 'Theme Mode',
          subtitle: 'Choose your preferred theme mode',
          children: [
            Row(
              children: [
                Expanded(
                  child: _ThemeCard(
                    title: 'System',
                    icon: Icons.brightness_auto,
                    isSelected: currentMode == AdaptiveThemeMode.system,
                    onTap: () {
                      AdaptiveTheme.of(context).setSystem();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ThemeCard(
                    title: 'Light',
                    icon: Icons.wb_sunny,
                    isSelected: currentMode == AdaptiveThemeMode.light,
                    onTap: () {
                      AdaptiveTheme.of(context).setLight();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ThemeCard(
                    title: 'Dark',
                    icon: Icons.nightlight_round,
                    isSelected: currentMode == AdaptiveThemeMode.dark,
                    onTap: () {
                      AdaptiveTheme.of(context).setDark();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Built-in theme presets
        _SettingsSection(
          title: 'Theme Presets',
          subtitle: 'Choose from pre-designed themes',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: BuiltInThemes.all.map((presetTheme) {
                final isSelected = customTheme.name == presetTheme.name;
                return _PresetThemeCard(
                  theme: presetTheme,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(customThemeProvider.notifier)
                        .setTheme(presetTheme);
                  },
                );
              }).toList(),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Custom theme colors
        _SettingsSection(
          title: 'Customize Colors',
          subtitle: 'Personalize your theme colors',
          children: [
            ColorPickerButton(
              color: customTheme.primaryColor,
              label: 'Primary Color',
              onColorChanged: (color) {
                ref.read(customThemeProvider.notifier).updateTheme(
                      (theme) => theme.copyWith(primaryColor: color),
                    );
              },
            ),
            const SizedBox(height: 12),
            ColorPickerButton(
              color: customTheme.secondaryColor,
              label: 'Secondary Color',
              onColorChanged: (color) {
                ref.read(customThemeProvider.notifier).updateTheme(
                      (theme) => theme.copyWith(secondaryColor: color),
                    );
              },
            ),
            const SizedBox(height: 12),
            ColorPickerButton(
              color: customTheme.surfaceColor,
              label: 'Surface Color',
              onColorChanged: (color) {
                ref.read(customThemeProvider.notifier).updateTheme(
                      (theme) => theme.copyWith(surfaceColor: color),
                    );
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Font settings
        _SettingsSection(
          title: 'Typography',
          subtitle: 'Customize fonts and text appearance',
          children: [
            FontFamilySelector(
              currentFontFamily: fontSettings.fontFamily,
              onFontFamilyChanged: (fontFamily) {
                ref
                    .read(fontSettingsProvider.notifier)
                    .setFontFamily(fontFamily);
              },
            ),
            const SizedBox(height: 16),
            FontSizeSelector(
              currentFontSize: fontSettings.fontSize,
              onFontSizeChanged: (fontSize) {
                ref.read(fontSettingsProvider.notifier).setFontSize(fontSize);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : null,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Preset theme card widget
class _PresetThemeCard extends StatelessWidget {
  const _PresetThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  final CustomThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? theme.primaryColor.withOpacity(0.1)
                : themeData.colorScheme.surfaceContainerHighest
                    .withOpacity(0.3),
            border: Border.all(
              color: isSelected
                  ? theme.primaryColor.withOpacity(0.3)
                  : themeData.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              // Color preview
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                theme.name,
                style: themeData.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : null,
                  color: isSelected
                      ? theme.primaryColor
                      : themeData.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
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
