import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'model/language_model.dart';

class Global {
  static List<LanguageModel> languages = [
    LanguageModel('English', 'en', 'US'),
    LanguageModel('简体中文', 'zh-Hans', 'CN'),
    LanguageModel('繁体中文', 'zh-Hant', 'HK'),
    LanguageModel('ไทย', 'th', 'TH'),
  ];

  //初始化全局信息
  static Future init(
    VoidCallback callback, {
    int orientation = 0,
    List<LanguageModel>? languages,
    double mobileW = 375.0,
    double mobileH = 812.0,
    double desktopW = 1920.0,
    double desktopH = 1080.0,
  }) async {
    Global.languages = languages ?? Global.languages;
    //确保初始化完成才可用
    WidgetsFlutterBinding.ensureInitialized();
    //sp release初始化30毫秒，debug初始化100毫秒
    await GetStorage.init();
    callback();

    if (orientation == 0) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }
}
