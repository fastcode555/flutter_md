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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        maxLines: null,
        controller: widget.controller,
        decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
