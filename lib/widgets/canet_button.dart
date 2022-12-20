import 'package:flutter/material.dart';
import 'package:xdlibrary/xdlibrary.dart';

import 'special_caret_widget.dart';

/// @date 20/9/22
/// describe:
///特殊符号的按钮
class CaretButton extends StatelessWidget {
  final ValueChanged<String> onTap;
  final HoverController _hoverController = HoverController();

  CaretButton({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlayHover(
      controller: _hoverController,
      hoverWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [BoxShadow(color: Colors.black38, offset: Offset(0, 3), blurRadius: 10)],
        ),
        child: SpecialCaretWidget(onTap: (model) {
          onTap(model);
          _hoverController.hide();
        }),
      ),
      child: IconButton(
        icon: const Icon(Icons.format_quote_outlined),
        onPressed: () {},
      ),
    );
  }
}
