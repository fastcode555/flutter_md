import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import '../builders/image_builder.dart';
import '../link_tap_builder.dart';
import 'utils.dart';

/// @date 17/8/22
/// describe:
class RichTextParser {
  ///标记文本
  static final RegExp _markReg = RegExp(r'`.*?`');
  static final RegExp _markRegContent = RegExp(r'(?<=`).*?(?=`)');

  static final RegExp _equalReg = RegExp(r'==.*?==');
  static final RegExp _equalRegContent = RegExp(r'(?<===).*?(?===)');

  ///波浪线
  static final RegExp _waveReg = RegExp(r'~\d+~');
  static final RegExp _waveRegContent = RegExp(r'(?<=~)\d+(?=~)');

  ///粗体
  static final RegExp _strongExp = RegExp(r'\*\*.*?\*\*');
  static final RegExp _strongExpContent = RegExp(r'(?<=\*\*).*?(?=\*\*)');

  ///斜体
  static final RegExp _italicExp = RegExp(r'\*.*?\*');
  static final RegExp _italicExpContent = RegExp(r'(?<=\*).*?(?=\*)');

  ///del 删除线文本
  static final RegExp _delExp = RegExp(r'~~.*?~~');
  static final RegExp _delExpContent = RegExp(r'(?<=~~).*?(?=~~)');

  static final RegExp _upperExp = RegExp(r'\^\d+\^');
  static final RegExp _upperExpContent = RegExp(r'(?<=\^)\d+(?=\^)');

  ///图片的正则
  static final RegExp _imgExp = RegExp(r'!\[.*?\]\(.*?\)');

  ///普通链接的正则
  static final RegExp _urlExp = RegExp(r'\[.*?\]\(.*?\)');

  ///即获取中括号里面的内容,为标题
  static final RegExp _titleExp = RegExp(r'(?<=\[).*?(?=\])');

  ///即获取括号里面的内容
  static final RegExp _contentExp = RegExp(r'(?<=\().*?(?=\))');

  ///暂时先这样解析，等到要编写一个全新的markdown widget的时候，再做结构调整
  static List<InlineSpan> parseString(String content, ImageBuilder imageBuilder, LinkTapBuilder tapBuilder) {
    List<InlineSpan> spans = [];
    if (content.contains("[") && _imgExp.hasMatch(content)) {
      //判断是否包含图片标签
      String? imgMdTag = _imgExp.firstMatch(content)?.group(0);
      if (imgMdTag != null && imgMdTag.isNotEmpty) {
        int index = content.indexOf(imgMdTag);
        String header = content.substring(0, index);
        String tail = content.substring(index + imgMdTag.length, content.length);
        if (header.isNotEmpty) {
          spans.addAll(parseString(header, imageBuilder, tapBuilder));
        }
        String title = _titleExp.firstMatch(imgMdTag)?.group(0) ?? '';
        String url = _contentExp.firstMatch(imgMdTag)?.group(0) ?? '';
        spans.add(
          WidgetSpan(
            child: imageBuilder.build(Uri.parse(url), title, title),
          ),
        );
        if (tail.isNotEmpty) {
          spans.addAll(parseString(tail, imageBuilder, tapBuilder));
        }
      }
    } else if (content.contains("[") && _urlExp.hasMatch(content)) {
      //判断是否包含链接标签
      String? urlMdTag = _urlExp.firstMatch(content)?.group(0);
      if (urlMdTag != null && urlMdTag.isNotEmpty) {
        int index = content.indexOf(urlMdTag);
        String header = content.substring(0, index);
        String tail = content.substring(index + urlMdTag.length, content.length);
        if (header.isNotEmpty) {
          spans.addAll(parseString(header, imageBuilder, tapBuilder));
        }
        String title = _titleExp.firstMatch(urlMdTag)?.group(0) ?? '';
        String url = _contentExp.firstMatch(urlMdTag)?.group(0) ?? '';
        spans.add(
          TextSpan(
            text: title,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                tapBuilder.onTap(title, url, title);
              },
            style: const TextStyle(color: Colors.blue),
          ),
        );
        if (tail.isNotEmpty) {
          spans.addAll(parseString(tail, imageBuilder, tapBuilder));
        }
      }
    } else if (_waveReg.hasMatch(content)) {
      //标记文本
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _waveReg,
        _waveRegContent,
        content,
        (value) {
          spans.add(TextSpan(text: Utils.getBottomNum(value)));
        },
      );
    } else if (_equalReg.hasMatch(content)) {
      //标记文本
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _equalReg,
        _equalRegContent,
        content,
        (value) {
          spans.add(TextSpan(text: value, style: const TextStyle(backgroundColor: Colors.yellow)));
        },
      );
    } else if (_strongExp.hasMatch(content)) {
      //strong文本
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _strongExp,
        _strongExpContent,
        content,
        (value) {
          spans.add(TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold)));
        },
      );
    } else if (_italicExp.hasMatch(content)) {
      //strong文本
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _italicExp,
        _italicExpContent,
        content,
        (value) {
          spans.add(TextSpan(text: value, style: const TextStyle(fontStyle: FontStyle.italic)));
        },
      );
    } else if (_delExp.hasMatch(content)) {
      //strong文本
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _delExp,
        _delExpContent,
        content,
        (value) {
          spans.add(TextSpan(text: value, style: const TextStyle(decoration: TextDecoration.lineThrough)));
        },
      );
    } else if (_upperExp.hasMatch(content)) {
      //数字
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _upperExp,
        _upperExpContent,
        content,
        (value) {
          spans.add(TextSpan(text: Utils.getTopNum(value)));
        },
      );
    } else if (_markReg.hasMatch(content)) {
      //标记文本
      _parse(
        imageBuilder,
        tapBuilder,
        spans,
        _markReg,
        _markRegContent,
        content,
        (value) {
          spans.add(
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      );
    } else {
      spans.add(TextSpan(text: content));
    }
    return spans;
  }

  ///通过正则解析内容
  static _parse(
    ImageBuilder imageBuilder,
    LinkTapBuilder tapBuilder,
    List<InlineSpan> spans,
    RegExp pattern,
    RegExp contentPatter,
    String content,
    ValueChanged<String> builder,
  ) {
    String result = pattern.firstMatch(content)!.group(0)!;
    int index = content.indexOf(result);
    String header = content.substring(0, index);
    String tail = content.substring(index + result.length, content.length);
    if (header.isNotEmpty) {
      spans.addAll(parseString(header, imageBuilder, tapBuilder));
    }
    String value = contentPatter.firstMatch(result)?.group(0) ?? result;
    builder.call(value);
    if (tail.isNotEmpty) {
      spans.addAll(parseString(tail, imageBuilder, tapBuilder));
    }
  }

  static List<InlineSpan> parseNode(
    md.Element element,
    ImageBuilder imageBuilder,
    LinkTapBuilder tapBuilder,
    TextStyle? preferredStyle,
  ) {
    List<InlineSpan> spans = [];

    for (md.Node node in element.children!) {
      if (node is md.Text) {
        spans.add(TextSpan(text: node.text));
      } else if (node is md.Element) {
        if (node.tag == 'a') {
          spans.add(
            TextSpan(
              text: node.textContent,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  tapBuilder.onTap(node.textContent, node.attributes['href'], node.textContent);
                },
            ),
          );
        } else if (node.tag == 'strong') {
          spans.add(
            TextSpan(
              text: node.textContent,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else if (node.tag == 'font') {
          spans.add(
            TextSpan(
              children: parseString(node.textContent, imageBuilder, tapBuilder),
            ),
          );
        } else if (node.tag == 'del') {
          spans.add(
            TextSpan(text: node.textContent, style: const TextStyle(decoration: TextDecoration.lineThrough)),
          );
        } else if (node.tag == 'em') {
          spans.add(
            TextSpan(text: node.textContent, style: const TextStyle(fontStyle: FontStyle.italic)),
          );
        } else if (node.tag == '`') {
          Utils.addIgnore(node.generatedId);
          spans.add(
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: Text(
                  node.textContent,
                  style: (preferredStyle ?? const TextStyle()).copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        } else if (node.tag == '==') {
          Utils.addIgnore(node.generatedId);
          //标记文本
          spans.add(
            TextSpan(
              text: node.textContent,
              style: (preferredStyle ?? const TextStyle()).copyWith(backgroundColor: Colors.yellow),
            ),
          );
        } else if (node.tag == '~') {
          Utils.addIgnore(node.generatedId);
          //下标数字
          spans.add(
            TextSpan(text: Utils.getBottomNum(node.textContent), style: preferredStyle),
          );
        } else if (node.tag == '^') {
          Utils.addIgnore(node.generatedId);
          //上标数字
          spans.add(
            TextSpan(text: Utils.getTopNum(node.textContent), style: preferredStyle),
          );
        }
      }
    }
    return spans;
  }
}
