import 'package:flutter/material.dart';
import 'package:flutter_md/widgets/auto_md_editor.dart';

/// @date 6/9/22
/// describe: 编辑器页面
class MdEditorPanel extends StatefulWidget {
  final TextEditingController controller;

  const MdEditorPanel({required this.controller, super.key});

  @override
  _MdEditorPanelState createState() => _MdEditorPanelState();
}

class _MdEditorPanelState extends State<MdEditorPanel> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          return AutoMdEditor(
            controller: widget.controller,
            focusNode: _focusNode,
            hintWidth: constraints.maxWidth,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
}
