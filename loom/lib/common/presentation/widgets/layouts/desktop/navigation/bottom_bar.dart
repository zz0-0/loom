import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';

/// Extensible bottom bar that displays registered items
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late final BottomBarRegistry _registry;

  @override
  void initState() {
    super.initState();
    _registry = BottomBarRegistry();
    _registerDefaultItems();
  }

  void _registerDefaultItems() {
    // Register default items
    final defaultItems = [
      // StatusBottomBarItem(),
      const FileTypeBottomBarItem(),
      const CursorPositionBottomBarItem(),
      const BloxDocumentInfoBottomBarItem(),
      const PreviewModeBottomBarItem(),
      // EncodingBottomBarItem(),
      // LineEndingBottomBarItem(),
    ];
    _registry.registerItems(defaultItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _registry.items;

    return Container(
      height: AppTheme.bottomBarHeight,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingHorizontalSm,
        child: Row(
          children: [
            // Left side items
            ...items
                .where((item) => item.priority < 100)
                .map((item) => item.build(context)),

            // Spacer
            const Spacer(),

            // Right side items
            ...items
                .where((item) => item.priority >= 100)
                .map((item) => item.build(context)),
          ],
        ),
      ),
    );
  }
}

// /// Default status items for the bottom bar
// class StatusBottomBarItem implements BottomBarItem {
//   @override
//   String get id => 'status';

//   @override
//   int get priority => 1;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.circle,
//             size: 8,
//             color: Colors.green,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             'Ready',
//             style: theme.textTheme.bodySmall,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class EncodingBottomBarItem implements BottomBarItem {
//   @override
//   String get id => 'encoding';

//   @override
//   int get priority => 101;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: Text(
//         'UTF-8',
//         style: theme.textTheme.bodySmall,
//       ),
//     );
//   }
// }

// class LineEndingBottomBarItem implements BottomBarItem {
//   @override
//   String get id => 'line_ending';

//   @override
//   int get priority => 102;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: Text(
//         'LF',
//         style: theme.textTheme.bodySmall,
//       ),
//     );
//   }
// }
