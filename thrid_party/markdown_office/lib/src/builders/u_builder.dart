import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 16/8/22
/// describe:解析<U>标签
class UBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return _UBuilderWidget(element, preferredStyle: preferredStyle);
  }
}

class _UBuilderWidget extends StatelessWidget {
  final md.Element element;
  final TextStyle? preferredStyle;

  const _UBuilderWidget(this.element, {this.preferredStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      element.textContent,
      style: (preferredStyle ?? const TextStyle()).copyWith(decoration: TextDecoration.underline),
      textAlign: TextAlign.center,
    );
  }
}
