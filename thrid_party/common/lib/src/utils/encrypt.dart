import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Encrypt {
  Encrypt._();

  static const Uuid _uuid = Uuid();

  // md5 加密
  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static String generateHeroTag(List<String> args) => generateMd5(args.toString());

  ///根据json生成唯一的herotag,后面看有没有必要使用uuid
  static String jsonHero(Map map) => generateMd5(map.toString());

  ///计算文件的md5值
  static Future<String?> calculateMD5SumAsyncWithCrypto(String filePath) async {
    var ret = '';
    var file = File(filePath);
    if (await file.exists()) {
      ret = hex.encode((await md5.bind(file.openRead()).first).bytes);
    } else {
      debugPrint('`$filePath` does not exits so unable to evaluate its MD5 sum.');
      return null;
    }
    debugPrint("calculateMD5SumAsyncWithCrypto = $ret");
    return ret;
  }

  static String createHeroTag(String url) => generateMd5(url + _uuid.v1());

  static String createUUID() => _uuid.v1();
}
