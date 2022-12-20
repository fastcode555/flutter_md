import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../utils/utils.dart';

/// @date 16/8/22
/// describe: 符号包裹文字的内容解析
class SymbolBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.generatedId != null && Utils.ignoreIds.contains(element.generatedId)) {
      return const SizedBox();
    }
    if (element.tag == '`') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.red.withOpacity(0.1),
        ),
        child: Text(
          element.textContent,
          style: const TextStyle(color: Colors.red).merge(preferredStyle),
          textAlign: TextAlign.center,
        ),
      );
    } else if (element.tag == '==') {
      //标记文本
      return Text(
        element.textContent,
        style: const TextStyle(backgroundColor: Colors.yellow).merge(preferredStyle),
      );
    } else if (element.tag == '~') {
      //下标数字
      return Text(Utils.getBottomNum(element.textContent), style: preferredStyle);
    } else if (element.tag == '^') {
      //上标数字
      return Text(Utils.getTopNum(element.textContent), style: preferredStyle);
    }
    return null;
  }
}
