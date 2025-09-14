import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// A resizable side panel that allows users to drag the edge to change its width
class ResizableSidePanel extends ConsumerStatefulWidget {
  const ResizableSidePanel({
    required this.child,
    required this.onWidthChanged,
    this.minWidth = 200.0,
    this.maxWidth = 800.0,
    super.key,
  });

  final Widget child;
  final ValueChanged<double> onWidthChanged;
  final double minWidth;
  final double maxWidth;

  @override
  ConsumerState<ResizableSidePanel> createState() => _ResizableSidePanelState();
}

class _ResizableSidePanelState extends ConsumerState<ResizableSidePanel> {
  bool _isResizing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // The side panel content
        Expanded(
          child: widget.child,
        ),

        // Resize handle
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            onHorizontalDragStart: (_) {
              setState(() {
                _isResizing = true;
              });
            },
            onHorizontalDragUpdate: (details) {
              final uiState = ref.read(uiStateProvider);
              final newWidth = (uiState.sidePanelWidth + details.delta.dx)
                  .clamp(widget.minWidth, widget.maxWidth);

              widget.onWidthChanged(newWidth);
            },
            onHorizontalDragEnd: (_) {
              setState(() {
                _isResizing = false;
              });
            },
            child: Container(
              width: 1,
              color: _isResizing
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : Colors.transparent,
              child: Center(
                child: Container(
                  width: 2,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
