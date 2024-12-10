import 'package:flutter/material.dart';

/// @date 3/9/22
/// describe:
class HoverWidget extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final BoxDecoration? decoration;
  final BoxDecoration? hoverDecoration;
  final bool animation;
  final EdgeInsetsGeometry? padding;

  const HoverWidget.animation({
    required this.builder,
    Key? key,
    this.decoration,
    this.hoverDecoration,
    this.padding,
  })  : animation = true,
        super(key: key);

  const HoverWidget({
    required this.builder,
    Key? key,
    this.decoration,
    this.hoverDecoration,
    this.padding,
  })  : animation = false,
        super(key: key);

  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<HoverWidget> {
  bool isHovered = false;
  Matrix4? hovered;

  @override
  Widget build(BuildContext context) {
    if (widget.animation) {
      hovered ??= Matrix4.identity()..translate(0, -10);
    }
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: AnimatedContainer(
        padding: widget.padding,
        duration: const Duration(milliseconds: 300),
        decoration: isHovered ? widget.hoverDecoration : widget.decoration,
        transform: widget.animation ? (isHovered ? hovered : Matrix4.identity()) : null,
        child: widget.builder(isHovered),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
