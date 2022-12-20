import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

/// @date 22/7/22
/// describe:
extension StringExt on String? {
  String get availableLocalPath {
    if (this == null) return this ?? '';
    int index = this!.indexOf('/Users');
    return this!.substring(index, this!.length);
  }

  ///null或者长度为0
  bool get isNullorEmpty => this == null || this!.isEmpty;

  ///有值
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;

  String formatter(List<String> _formatters) => sprintf(this!, _formatters);

  double get secureDouble {
    try {
      if (this == null || this!.isEmpty) {
        return 0;
      } else {
        return double.parse(this!);
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  int get secureInt {
    try {
      if (this == null || this!.isEmpty) {
        return 0;
      } else {
        return int.parse(this!);
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  num get secureNum {
    if (this == null || this!.isEmpty) return 0;
    if (this!.contains('.')) {
      return secureDouble;
    } else {
      return secureInt;
    }
  }

//计算文本占用宽高
  double paintWidthWithTextStyle(TextStyle style, {double? maxWidth}) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: this, style: style), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
    return textPainter.size.width;
  }

  double paintHeightWithTextStyle(TextStyle style, {double? maxWidth}) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: this, style: style), textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
    return textPainter.size.height;
  }

//匹配中括号的内容
  static final RegExp _regex = RegExp(r"\[([^\[\]]*)\]");

//第一个颜色为文本的默认颜色,其它颜色为为格式化的富文本的颜色,匹配中括号内的东西,中括号内的作为富文本不同颜色的部分,
// 正则匹配中括号的东西,传入的TextStyle列表,给对应中括号内容,设置不同颜色锋哥
  RichText formatColorRichText(
    List<TextStyle> styles, {
    TextAlign textAlign = TextAlign.left,
    TextOverflow overflow = TextOverflow.visible,
  }) {
    String content = this!;
    List<TextSpan> spans = [];
    Iterable<RegExpMatch> matchers = _regex.allMatches(this!);
    //第二个开始才是真正需要格式化的颜色
    int count = 1;
    TextStyle? style;
    for (Match m in matchers) {
      if (count < styles.length) {
        style = styles[count];
      }
      String? regexText = m.group(0);
      int index = content.indexOf(regexText!);
      //匹配出来的普通文本
      spans.add(TextSpan(text: content.substring(0, index)));
      content = content.substring(index, content.length);
      //切割余下的文本,去掉中括号,留下文本内容
      spans.add(TextSpan(text: regexText.substring(1, regexText.length - 1), style: style));
      content = content.substring(regexText.length, content.length);
      count++;
    }
    //剩余最后的内容
    spans.add(TextSpan(text: content));
    return RichText(
      textAlign: textAlign,
      overflow: overflow,
      text: TextSpan(
        text: '',
        style: styles[0],
        children: spans,
      ),
    );
  }
}
