import 'package:common/common.dart';
import 'package:flutter/material.dart';

void showPoup(
  BuildContext context, {
  required Widget child,
  BoxConstraints? constraints,
}) {
  Offset? offset = context.location();
  if (offset != null) {
    showMenu<String>(
      context: context,
      constraints: constraints,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(width: 1.0, color: context.primaryColor, style: BorderStyle.solid),
      ),
      position: _dealCenterPosition(context, offset),
      items: [
        PopupMenuItem<String>(
          value: '',
          height: 25,
          enabled: false,
          onTap: () {},
          child: child,
        )
      ],
    );
  }
}

///计算弹窗的相对位置
RelativeRect _dealCenterPosition(BuildContext context, Offset offset) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = (Overlay.of(context)?.context.findRenderObject()) as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );
  return position;
}

typedef TextBuilder = String Function(String text);
