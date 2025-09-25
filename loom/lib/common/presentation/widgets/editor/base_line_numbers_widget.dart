import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';

/// Base class for line number widgets in different editor modes
abstract class BaseLineNumbersWidget extends StatelessWidget {
  const BaseLineNumbersWidget({
    required this.scrollController,
    required this.theme,
    super.key,
    this.width = AppDimensions.lineNumbersWidth,
  });

  final ScrollController scrollController;
  final ThemeData theme;
  final double width;

  /// Get the list of line numbers to display
  List<int> getLineNumbers();

  /// Get the height for each line number
  List<double> getLineHeights();

  /// Get the total number of lines
  int get totalLines => getLineNumbers().length;

  @override
  Widget build(BuildContext context) {
    final lineNumbers = getLineNumbers();
    final lineHeights = getLineHeights();

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.sm,
            left: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: lineNumbers.asMap().entries.map((entry) {
              final index = entry.key;
              final lineNumber = entry.value;
              final lineHeight = index < lineHeights.length
                  ? lineHeights[index]
                  : AppDimensions.listItemHeight;

              return Container(
                height: lineHeight,
                alignment: Alignment.topRight,
                padding: AppSpacing.paddingRightSm,
                child: SizedBox(
                  width: AppDimensions.lineNumbersMinWidth,
                  child: Text(
                    '$lineNumber',
                    style: AppTypography.lineNumbersTextStyle.copyWith(
                      color:
                          theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
