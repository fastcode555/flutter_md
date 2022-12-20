import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_office/src/link_tap_builder.dart';

import '../utils/richtext_parser.dart';
import 'image_builder.dart';

/// @date 15/8/22
/// describe:
class HBuilder extends MarkdownElementBuilder {
  final ImageBuilder imageBuilder;
  final LinkTapBuilder tapBuilder;
  md.Element? parentElement;

  HBuilder(this.imageBuilder, this.tapBuilder);

  @override
  void visitElementBefore(md.Element element) {
    debugPrint(element.toString());
    if (element.children!.length >= 2) {
      parentElement = element;
    } else {
      parentElement = null;
    }
  }

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    if (parentElement != null) {
      if (parentElement!.children![0] == text) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(children: RichTextParser.parseNode(parentElement!, imageBuilder, tapBuilder, preferredStyle)),
              style: preferredStyle,
            ),
            const Divider(),
          ],
        );
      } else {
        return const SizedBox();
      }
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text.textContent, style: preferredStyle),
          const Divider(),
        ],
      );
    }
  }
}
