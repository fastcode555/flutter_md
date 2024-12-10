import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

/// @date 15/8/22
/// describe:代码高亮部分的处理
class CustomSyntaxHightlighter extends SyntaxHighlighter {
  late Map<String, TextStyle> _theme;

  CustomSyntaxHightlighter() {
    _theme = Map.from(githubTheme);
    _theme['root'] = const TextStyle(color: Color(0xff333333), backgroundColor: Colors.transparent);
  }

  @override
  TextSpan format(String source) {
    var textStyle = TextStyle(
      fontFamily: 'monospace',
      color: _theme['root']?.color ?? const Color(0xffffffff),
    );
    return TextSpan(
      style: textStyle,
      children: _convert(highlight.parse(source, language: 'dart').nodes!),
    );
  }

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: _theme[node.className!]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: _theme[node.className!]));
        stack.add(currentSpans);
        currentSpans = tmp;

        for (var n in node.children!) {
          traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    for (var node in nodes) {
      traverse(node);
    }
    return spans;
  }
}
