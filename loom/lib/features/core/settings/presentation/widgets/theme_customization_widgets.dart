import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:loom/common/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Color picker dialog for theme customization
class ThemeColorPicker extends StatefulWidget {
  const ThemeColorPicker({
    required this.initialColor,
    required this.title,
    required this.onColorChanged,
    super.key,
  });

  final Color initialColor;
  final String title;
  final ValueChanged<Color> onColorChanged;

  @override
  State<ThemeColorPicker> createState() => _ThemeColorPickerState();
}

class _ThemeColorPickerState extends State<ThemeColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  _currentColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              pickerAreaBorderRadius: AppRadius.radiusMd,
            ),
            const SizedBox(height: 16),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  loc.preview,
                  style: TextStyle(
                    color: _currentColor.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onColorChanged(_currentColor);
            Navigator.of(context).pop();
          },
          child: Text(loc.apply),
        ),
      ],
    );
  }
}

/// Color picker button widget
class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({
    required this.color,
    required this.label,
    required this.onColorChanged,
    super.key,
  });

  final Color color;
  final String label;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return InkWell(
      onTap: () async {
        final result = await showDialog<Color>(
          context: context,
          builder: (context) => ThemeColorPicker(
            initialColor: color,
            title: loc.selectColorLabel(label),
            onColorChanged: (color) => Navigator.of(context).pop(color),
          ),
        );

        if (result != null) {
          onColorChanged(result);
        }
      },
      borderRadius: AppRadius.radiusMd,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: AppRadius.radiusMd,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadius.radiusSm,
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.color_lens,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Font family selector
class FontFamilySelector extends StatelessWidget {
  const FontFamilySelector({
    required this.currentFontFamily,
    required this.onFontFamilyChanged,
    super.key,
  });

  final String currentFontFamily;
  final ValueChanged<String> onFontFamilyChanged;

  static const List<String> availableFonts = [
    'Inter',
    'Roboto',
    'Open Sans',
    'serif',
    'sans-serif',
    'monospace',
    'cursive',
    'fantasy',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.fontFamilyLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentFontFamily,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusMd,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.smd,
              vertical: AppSpacing.sm,
            ),
          ),
          items: availableFonts.map((font) {
            return DropdownMenuItem<String>(
              value: font,
              child: Text(
                font,
                style: TextStyle(fontFamily: font),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onFontFamilyChanged(value);
            }
          },
        ),
        const SizedBox(height: 8),
        // Preview text with current font
        Container(
          padding: AppSpacing.paddingSm,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: AppRadius.radiusSm,
          ),
          child: Text(
            loc.previewSampleText,
            style: TextStyle(
              fontFamily: currentFontFamily,
              fontSize: 14,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Font size selector
class FontSizeSelector extends StatelessWidget {
  const FontSizeSelector({
    required this.currentFontSize,
    required this.onFontSizeChanged,
    super.key,
  });

  final double currentFontSize;
  final ValueChanged<double> onFontSizeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.fontSizeLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: currentFontSize,
                min: 10,
                max: 20,
                divisions: 10,
                label: currentFontSize.round().toString(),
                onChanged: onFontSizeChanged,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text(
                '${currentFontSize.round()}px',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
