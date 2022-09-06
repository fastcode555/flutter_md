import 'package:flutter/material.dart';

/// @date 6/9/22
/// describe: 编辑器页面
class MdEditorPanel extends StatefulWidget {
  final TextEditingController controller;

  const MdEditorPanel({required this.controller, super.key});

  @override
  _MdEditorPanelState createState() => _MdEditorPanelState();
}

class _MdEditorPanelState extends State<MdEditorPanel> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: widget.controller,
    );
  }
}
