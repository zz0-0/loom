import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Theme settings widget
class ThemeSettings extends ConsumerWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customTheme = ref.watch(customThemeProvider);
    final fontSettings = ref.watch(fontSettingsProvider);
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.theme,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Current theme info
        _SettingsSection(
          title: localizations.currentTheme,
          subtitle: localizations.currentThemeDescription,
          children: [
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: AppRadius.radiusLg,
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customTheme.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.smd),
                  Text(
                    localizations.colorScheme,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _ColorSwatch(
                        color: customTheme.primaryColor,
                        label: localizations.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _ColorSwatch(
                        color: customTheme.secondaryColor,
                        label: localizations.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _ColorSwatch(
                        color: customTheme.surfaceColor,
                        label: localizations.surface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Built-in theme presets
        _SettingsSection(
          title: localizations.themePresets,
          subtitle: localizations.themePresetsDescription,
          children: [
            // System themes
            _ThemeGroup(
              title: localizations.systemThemes,
              themes: BuiltInThemes.systemThemes,
              currentTheme: customTheme,
              onThemeSelected: (theme) {
                ref.read(customThemeProvider.notifier).setTheme(theme);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Light themes
            _ThemeGroup(
              title: localizations.lightThemes,
              themes: BuiltInThemes.lightThemes,
              currentTheme: customTheme,
              onThemeSelected: (theme) {
                ref.read(customThemeProvider.notifier).setTheme(theme);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Dark themes
            _ThemeGroup(
              title: localizations.darkThemes,
              themes: BuiltInThemes.darkThemes,
              currentTheme: customTheme,
              onThemeSelected: (theme) {
                ref.read(customThemeProvider.notifier).setTheme(theme);
              },
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),

        // Custom theme colors
        _SettingsSection(
          title: localizations.customizeColors,
          subtitle: localizations.customizeColorsDescription,
          children: [
            ColorPickerButton(
              color: customTheme.primaryColor,
              label: localizations.primaryColor,
              onColorChanged: (color) {
                ref.read(customThemeProvider.notifier).updateTheme(
                      (theme) => theme.copyWith(primaryColor: color),
                    );
              },
            ),
            const SizedBox(height: AppSpacing.smd),
            ColorPickerButton(
              color: customTheme.secondaryColor,
              label: localizations.secondaryColor,
              onColorChanged: (color) {
                ref.read(customThemeProvider.notifier).updateTheme(
                      (theme) => theme.copyWith(secondaryColor: color),
                    );
              },
            ),
            const SizedBox(height: AppSpacing.smd),
            ColorPickerButton(
              color: customTheme.surfaceColor,
              label: localizations.surfaceColor,
              onColorChanged: (color) {
                ref.read(customThemeProvider.notifier).updateTheme(
                      (theme) => theme.copyWith(surfaceColor: color),
                    );
              },
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),

        // Font settings
        _SettingsSection(
          title: localizations.typography,
          subtitle: localizations.typographyDescription,
          children: [
            FontFamilySelector(
              currentFontFamily: fontSettings.fontFamily,
              onFontFamilyChanged: (fontFamily) {
                ref
                    .read(fontSettingsProvider.notifier)
                    .setFontFamily(fontFamily);
              },
            ),
            const SizedBox(height: AppSpacing.md),
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
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusLg,
        child: Container(
          width: 120,
          height: 100, // Fixed height to prevent size variations
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusLg,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Color preview
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: AppDimensions.iconLarge,
                    height: AppDimensions.iconLarge,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: AppRadius.radiusXs,
                      border: Border.all(
                        color: themeData.colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: AppDimensions.iconLarge,
                    height: AppDimensions.iconLarge,
                    decoration: BoxDecoration(
                      color: theme.secondaryColor,
                      borderRadius: AppRadius.radiusXs,
                      border: Border.all(
                        color: themeData.colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: AppDimensions.iconLarge,
                    height: AppDimensions.iconLarge,
                    decoration: BoxDecoration(
                      color: theme.surfaceColor,
                      borderRadius: AppRadius.radiusXs,
                      border: Border.all(
                        color: themeData.colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Center(
                  child: Text(
                    theme.name,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : null,
                      color: isSelected
                          ? theme.primaryColor
                          : themeData.colorScheme.onSurface,
                      fontSize: AppTypography
                          .extraSmall, // Slightly smaller to fit better
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }
}

/// Theme group widget for organizing themes by category
class _ThemeGroup extends StatelessWidget {
  const _ThemeGroup({
    required this.title,
    required this.themes,
    required this.currentTheme,
    required this.onThemeSelected,
  });

  final String title;
  final List<CustomThemeData> themes;
  final CustomThemeData currentTheme;
  final void Function(CustomThemeData) onThemeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: themes.map((presetTheme) {
            final isSelected = currentTheme.name == presetTheme.name;
            return _PresetThemeCard(
              theme: presetTheme,
              isSelected: isSelected,
              onTap: () => onThemeSelected(presetTheme),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Color swatch widget for theme preview
class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.radiusXs,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: AppTypography.tiny,
          ),
        ),
      ],
    );
  }
}
