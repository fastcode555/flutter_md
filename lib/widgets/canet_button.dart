import 'package:flutter/material.dart';

import 'poup/poup_manager.dart';
import 'special_caret_widget.dart';

/// @date 20/9/22
/// describe:
///特殊符号的按钮
class CaretButton extends StatelessWidget {
  final ValueChanged<String> onTap;

  const CaretButton({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isShow = false;
    return MouseRegion(
      onEnter: (_) {
        if (isShow) return;
        isShow = true;
        showPoup(context, child: SpecialCaretWidget(onTap: onTap));
      },
      onExit: (_) {
        if (isShow) {
          isShow = false;
        }
      },
      child: IconButton(
        icon: const Icon(Icons.format_quote_outlined),
        onPressed: () {},
      ),
    );
  }
}
