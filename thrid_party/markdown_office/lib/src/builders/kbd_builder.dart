import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 16/8/22
/// describe:解析<KBD>标签
class KbdBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return _KbdBuilderWidget(element, preferredStyle: preferredStyle);
  }
}

class _KbdBuilderWidget extends StatelessWidget {
  final md.Element element;
  final TextStyle? preferredStyle;

  const _KbdBuilderWidget(this.element, {this.preferredStyle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.primaryColor, width: 1.0),
      ),
      child: Text(
        element.textContent,
        style: preferredStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
