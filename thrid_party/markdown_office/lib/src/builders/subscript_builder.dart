import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 15/8/22
/// describe:数学公式
class SubscriptBuilder extends MarkdownElementBuilder {
  static const List<String> _subscripts = <String>['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String textContent = element.textContent;
    String text = '';
    for (int i = 0; i < textContent.length; i++) {
      text += _subscripts[int.parse(textContent[i])];
    }
    return Text.rich(TextSpan(text: text));
  }
}

class SubscriptSyntax extends md.InlineSyntax {
  SubscriptSyntax() : super(_pattern);

  static const String _pattern = r'_([0-9]+)';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.text('sub', match[1]!));
    return true;
  }
}
