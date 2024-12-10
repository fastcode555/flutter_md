import 'package:flutter/material.dart';

/// Custom text selection controls using modern contextMenuBuilder approach
class MyTextSelectionMenuBuilder {
  static Widget buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}
