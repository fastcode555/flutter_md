import 'package:charcode/charcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_office/src/link_tap_builder.dart';

import '../utils/richtext_parser.dart';
import '../utils/utils.dart';
import 'image_builder.dart';

/// @date 15/8/22
/// describe: 解析<font/>标签
///
class FontBuilder extends MarkdownElementBuilder {
  final ImageBuilder imageBuilder;
  final LinkTapBuilder tapBuilder;

  FontBuilder(this.imageBuilder, this.tapBuilder);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.tag == "font") {
      //针对这次flutter 官方给出的markdown给出的框架，解决方案感觉不是特别好，使用的是ListView，然后每个节点使用的是Widget，根据常规的markdown
      //选择文本复制的时候应该是连续的,但是这里并不是。尝试将自己创建MarkdownBuilder，解析element，需要改比较多的源码，感觉后续flutter_markdown更新需要变更的东西很多，因此在这里只做一个简单的解析，
      //但解析出来采用的全部都是InlineSpan的方案，这样font标签的节点，文本就可以实现连续复制
      return Text.rich(
        TextSpan(
          children: RichTextParser.parseString(element.textContent, imageBuilder, tapBuilder),
        ),
        style: _buildNewStyle(preferredStyle, element.attributes),
      );
    }
    return null;
  }

  TextStyle? _buildNewStyle(TextStyle? preferredStyle, Map<String, String> attrs) {
    String? color = attrs['color'];
    if (color == null) return preferredStyle;
    return preferredStyle?.merge(TextStyle(color: Utils.getColor(color))) ?? TextStyle(color: Utils.getColor(color));
  }
}

class FontSyntax extends md.TextSyntax {
  static final _regAttr = RegExp(r'<font .*?=.*?>');
  static final _regAttrs = RegExp(r' .*?=.*?(?=[>| ])');
  static final _regContent = RegExp(r'(?<=>).*?(?=<)');
  static final _contentExp = RegExp(r'(?<=").*?(?=")');

  //FontSyntax() : super(r'<[/!?]?[A-Za-z][A-Za-z0-9-]*(?:\s[^>]*)?>', startCharacter: $lt);
  FontSyntax() : super(r'<font.*?>.*?</font>', startCharacter: $lt, sub: 'font');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if ((match.start > 0 && match.input.substring(match.start - 1, match.start) == '/')) {
      // Just use the original matched text.
      parser.advanceBy(match.group(0)!.length);
      return false;
    }
    String regexContent = match.group(0)!;
    if (_regContent.hasMatch(regexContent)) {
      String content = _regContent.firstMatch(regexContent)!.group(0)!;
      //如果里面还有其它的节点
      md.Element element = md.Element.text(substitute, content);
      /*  md.InlineParser inlineParser = md.InlineParser(content, parser.document);
      element.children?.addAll(inlineParser.parse());*/

      if (_regAttr.hasMatch(regexContent)) {
        String fontContent = _regAttr.firstMatch(regexContent)!.group(0)!;
        if (_regAttrs.hasMatch(fontContent)) {
          List<RegExpMatch> matches = _regAttrs.allMatches(fontContent).toList();
          for (RegExpMatch exp in matches) {
            List<String>? results = exp.group(0)?.split("=");
            if (results != null && results.isNotEmpty) {
              String value = results[1].trim();
              //取出双引号内的内容
              if (_contentExp.hasMatch(value)) {
                value = _contentExp.firstMatch(value)?.group(0) ?? value;
              }
              element.attributes[results[0].trim()] = value.trim();
            }
          }
        }
        parser.addNode(element);
      }
      return true;
    }
    return false;
  }
}
