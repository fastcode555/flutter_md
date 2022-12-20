import 'package:flutter/material.dart';
import 'package:xdlibrary/xdlibrary.dart';

import '../model/edit_action_model.dart';
import 'colour_widget.dart';

///颜色按钮
class FontColorButton extends StatelessWidget {
  final ValueNotifier<EditActionModel?>? notifier;
  final HoverController _controller = HoverController();

  FontColorButton({this.notifier, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlayHover(
      controller: _controller,
      hoverWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [BoxShadow(color: Colors.black38, offset: Offset(0, 3), blurRadius: 10)],
        ),
        constraints: const BoxConstraints(maxWidth: 200),
        child: ColourWidget(
          onTap: (color) {
            notifier?.value = EditActionModel(action: EditActionModel.font, content: color);
            _controller.hide();
          },
        ),
      ),
      child: IconButton(
        onPressed: () => notifier?.value = EditActionModel(action: EditActionModel.font, content: "red"),
        icon: const Icon(Icons.format_color_text),
      ),
    );
  }
}
