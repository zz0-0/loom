import 'package:flutter/material.dart';

/// Different modes for the Blox editor
enum BloxEditorMode {
  /// Standard editing mode with syntax highlighting
  editing,

  /// Standalone preview mode showing rendered Blox content
  preview,

  /// Side-by-side editing and preview
  sideBySide,

  /// Live preview that updates as you type
  livePreview,
}

/// Extension methods for BloxEditorMode
extension BloxEditorModeExtension on BloxEditorMode {
  String get displayName {
    switch (this) {
      case BloxEditorMode.editing:
        return 'Editing';
      case BloxEditorMode.preview:
        return 'Preview';
      case BloxEditorMode.sideBySide:
        return 'Side by Side';
      case BloxEditorMode.livePreview:
        return 'Live Preview';
    }
  }

  IconData get icon {
    switch (this) {
      case BloxEditorMode.editing:
        return Icons.edit;
      case BloxEditorMode.preview:
        return Icons.visibility;
      case BloxEditorMode.sideBySide:
        return Icons.view_sidebar;
      case BloxEditorMode.livePreview:
        return Icons.refresh;
    }
  }

  String get description {
    switch (this) {
      case BloxEditorMode.editing:
        return 'Edit Blox content with syntax highlighting';
      case BloxEditorMode.preview:
        return 'View rendered Blox content';
      case BloxEditorMode.sideBySide:
        return 'Edit and preview simultaneously';
      case BloxEditorMode.livePreview:
        return 'Live preview that updates as you type';
    }
  }
}
