import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 12/8/22
/// describe:
///
RegExp _regex = RegExp(r"=\d+x\d+");
String _picCenter = "pic_center";

class ImageBuilder extends MarkdownElementBuilder {
  final File? file;
  String dir = "";

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.tag == "html_img") {
      Map<String, String> attrs = element.attributes;
      return ExtendedImage.network(
        attrs['src'] ?? '',
        width: double.tryParse(attrs['width'] ?? ''),
        height: double.tryParse(attrs['height'] ?? ''),
      );
    }
    return null;
  }

  ImageBuilder(this.file) {
    dir = file?.path ?? '';
    dir = dir.replaceAll(dir.split('/').last, "");
  }

  Widget build(Uri uri, String? title, String? alt) {
    String path = uri.toString();
    if (path.startsWith("http")) {
      return _buildWidget(uri, title, alt);
    }
    //一般都使用相对地址，这里获取到了reademe文件的地址，然后跟相对地址合在一起，变成绝对地址，markdown才有办法解析
    return ExtendedImage.file(File("$dir$path"));
  }

  Widget _buildWidget(Uri uri, String? title, String? alt) {
    String path = uri.toString();
    //简单判断是否居中
    bool isAtCenter = path.contains("#$_picCenter");
    late Widget image;
    if (_regex.hasMatch(path)) {
      RegExpMatch? reg = _regex.firstMatch(path);
      String? result = reg?.group(0)?.replaceAll("=", "");
      if (result == null || result.isEmpty) {
        image = ExtendedImage.network(path);
      } else {
        List<String> results = result.split("x");
        String resultPath = path.replaceAll("=$result", '');
        image = ExtendedImage.network(
          resultPath,
          width: double.tryParse(results[0]),
          height: double.tryParse(results[1]),
        );
      }
    } else {
      image = ExtendedImage.network(path);
    }
    if (isAtCenter) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [image],
      );
    }
    return image;
  }
}
