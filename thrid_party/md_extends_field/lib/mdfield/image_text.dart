import 'dart:math';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';

class ImageText extends SpecialText {
  ImageText(
    TextStyle? textStyle, {
    this.start,
    SpecialTextGestureTapCallback? onTap,
  }) : super(ImageText.flag, '/>', textStyle, onTap: onTap);

  static const String flag = '<img';
  final int? start;
  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  @override
  InlineSpan finishText() {
    final String text = toString();

    final Document html = parse(text);

    final Element img = html.getElementsByTagName('img').first;
    final String url = img.attributes['src']!;
    _imageUrl = url;

    double? width = 60.0;
    double? height = 60.0;
    const BoxFit fit = BoxFit.cover;
    const double num300 = 60.0;
    const double num400 = 80.0;

    height = num300;
    width = num400;
    const bool knowImageSize = true;
    if (knowImageSize) {
      height = double.tryParse(img.attributes['height'] ?? '60');
      width = double.tryParse(img.attributes['width'] ?? '80');
      final double n = height! / width!;
      if (n >= 4 / 3) {
        width = num300;
        height = num400;
      } else if (4 / 3 > n && n > 3 / 4) {
        final double maxValue = max(width, height);
        height = num400 * height / maxValue;
        width = num400 * width / maxValue;
      } else if (n <= 3 / 4) {
        width = num400;
        height = num300;
      }
    }

    return ExtendedWidgetSpan(
      start: start!,
      actualText: text,
      child: GestureDetector(
        onTap: () => onTap?.call(url),
        child: Image.network(url, width: width, height: height, fit: fit),
      ),
    );
  }
}
