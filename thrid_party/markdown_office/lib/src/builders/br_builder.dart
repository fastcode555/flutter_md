import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 15/8/22
/// describe: 换行<br/>标签 或者\n的换行符
class BrBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return const SizedBox(width: double.infinity);
  }
}

class BrSyntax extends md.InlineSyntax {
  BrSyntax() : super(r'[<[/]*br[/]*>|\n]*');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String? data = match.group(0);
    if (data != null) {
      parser.addNode(md.Element.text('br', data));
      return true;
    }
    return false;
  }
}
