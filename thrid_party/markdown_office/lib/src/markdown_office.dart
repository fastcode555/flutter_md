import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_office/src/utils/utils.dart';

import 'builders/br_builder.dart';
import 'builders/font_builder.dart';
import 'builders/h_builder.dart';
import 'builders/image_builder.dart';
import 'builders/kbd_builder.dart';
import 'builders/mark_builder.dart';
import 'builders/subscript_builder.dart';
import 'builders/u_builder.dart';
import 'custom_syntax_hightlighter.dart';
import 'link_tap_builder.dart';
import 'syntaxes/common_syntaxes.dart';
import 'syntaxes/html_img_syntaxes.dart';

/// @date 15/8/22
/// describe: 使用官方的flutter markdown扩展的markdown阅读组件
int _openCount = 0;

class MarkdownOffice extends StatefulWidget {
  final File? file;
  final String? data;

  const MarkdownOffice({super.key, this.file, this.data}) : assert(file != null || data != null);

  @override
  _MarkdownOfficeState createState() => _MarkdownOfficeState();
}

class _MarkdownOfficeState extends State<MarkdownOffice> {
  late String _data;
  late ImageBuilder _imageBuilder;
  late LinkTapBuilder _tapBuilder;
  late HBuilder _hBuilder;
  Markdown? _markdown;

  @override
  void initState() {
    super.initState();
    _openCount++;
    _data = widget.file?.readAsStringSync() ?? widget.data ?? '';
    _imageBuilder = ImageBuilder(widget.file);
    _tapBuilder = LinkTapBuilder(widget.file);
    _hBuilder = HBuilder(_imageBuilder, _tapBuilder);
  }

  @override
  void didUpdateWidget(covariant MarkdownOffice oldWidget) {
    super.didUpdateWidget(oldWidget);
    String data = widget.data ?? widget.file?.readAsStringSync() ?? '';
    if (_data != data) {
      _data = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    _markdown = Markdown(
      data: _data,
      imageBuilder: _imageBuilder.build,
      onTapLink: _tapBuilder.onTap,
      syntaxHighlighter: CustomSyntaxHightlighter(),
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: context.primaryColor, width: 3)),
          color: context.primaryColor.withOpacity(0.05),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
          ),
        ),
        tableCellsDecoration: BoxDecoration(
          color: context.primaryColor.withOpacity(0.05),
        ),
      ),
      inlineSyntaxes: [
        BrSyntax(),
        FontSyntax(),
        SubscriptSyntax(),
        CommonSyntax(r'`.*?`', r'(?<=`).*?(?=`)', '`'),
        CommonSyntax(r'==.*?==', r'(?<===).*?(?===)', '=='),
        CommonSyntax(r'~\d+~', r'(?<=~)\d+(?=~)', '~'),
        CommonSyntax(r'\^\d+\^', r'(?<=\^)\d+(?=\^)', '^'),
        CommonSyntax(
          r'<[K|k][B|b][D|d]>.*?</[K|k][B|b][D|d]>',
          r'(?<=<[K|k][B|b][D|d]>).*?(?=</[K|k][B|b][D|d]>)',
          'kbd',
        ),
        CommonSyntax(
          r'<[U|u]>.*?</[U|u]>',
          r'(?<=<[U|u]>).*?(?=</[U|u]>)',
          'u',
        ),
        HtmlImgSyntax(),
      ],
      builders: {
        "h1": _hBuilder,
        "h2": _hBuilder,
        "h3": _hBuilder,
        "h4": _hBuilder,
        "h5": _hBuilder,
        "h6": _hBuilder,
        'br': BrBuilder(),
        'font': FontBuilder(_imageBuilder, _tapBuilder),
        'sub': SubscriptBuilder(),
        'kbd': KbdBuilder(),
        'u': UBuilder(),
        '`': SymbolBuilder(),
        '==': SymbolBuilder(),
        '~': SymbolBuilder(),
        '^': SymbolBuilder(),
        'html_img': _imageBuilder,
      },
    );
    return SelectionArea(child: _markdown!);
  }

  @override
  void dispose() {
    super.dispose();
    _openCount--;
    if (_openCount == 0) {
      Utils.ignoreIds.clear();
      print("clear the ignoreIds,清空里面的内容");
    }
  }
}
