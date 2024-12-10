import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

extension FileSystemEntityExt on FileSystemEntity {
  String get name {
    String path = this.path;
    int index = path.lastIndexOf(Platform.pathSeparator);
    String name = path.substring(index + 1, path.length);
    return name;
  }

  String get type => extension(path).replaceAll(".", "");

  String get fileExtension => extension(path);
}

extension FileExt on File {
  String get size {
    int value = lengthSync();
    List<String> unitArr = ['B', 'KB', 'MB', 'GB'];
    int index = 0;
    double size = value.toDouble();
    while (size > 1024) {
      index++;
      size = size / 1024;
    }
    String result = size.toStringAsFixed(2);
    return '$result${unitArr[index]}';
  }
}

class FileUtils {
  static Future<Directory> getAppDirectory() async {
    Directory tempDir;
    //web 居然isMacos为true
    debugPrint(
        'GetPlatform.isIOS=${GetPlatform.isIOS},GetPlatform.isMacOS=${GetPlatform.isMacOS}, GeneralPlatform.isWeb=${GetPlatform.isWeb}');
    if (GetPlatform.isIOS || GetPlatform.isMacOS) {
      tempDir = await getApplicationDocumentsDirectory();
    } else {
      tempDir = (await getExternalStorageDirectory())!;
    }
    String tempPath = "${tempDir.path}/";
    Directory file = Directory(tempPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  static Future<Directory> getAppApkDirectory() async {
    Directory tempDir;
    if (GetPlatform.isIOS) {
      tempDir = await getApplicationDocumentsDirectory();
    } else {
      tempDir = (await getExternalStorageDirectory())!;
    }
    String tempPath = "${tempDir.path}/apk";
    Directory file = Directory(tempPath);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  /// md5 加密
  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static Future<File> getImageFileFromAssets(ByteData byteData, {String? name, String? dirName = 'localImgs'}) async {
    // Store the picture in the temp directory.
    // Find the temp directory using the `path_provider` plugin.
    String path = "${(await getAppDirectory()).path}$dirName/";
    Directory _dir = Directory(path);
    if (!_dir.existsSync()) _dir.createSync();
    final file = File('${_dir.path}${name ?? DateTime.now().millisecond}.jpg');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  static Future<File> getImageFileFromUnit8list(Uint8List unit8list,
      {String? name, String? dirName = 'localImgs'}) async {
    // Store the picture in the temp directory.
    // Find the temp directory using the `path_provider` plugin.
    String path = "${(await getAppDirectory()).path}$dirName/";
    Directory _dir = Directory(path);
    if (!_dir.existsSync()) _dir.createSync();
    final file = File('${_dir.path}${name ?? DateTime.now().millisecond}.jpg');
    await file.writeAsBytes(unit8list);
    return file;
  }
}
