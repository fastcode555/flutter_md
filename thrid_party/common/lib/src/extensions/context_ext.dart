import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// @date 2020/10/20
/// describe:
extension ContextExt on BuildContext {
  //屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;

  //屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;

  //获取系统状态栏高度
  double get statusHeight => MediaQuery.of(this).padding.top;

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  //系统默认字体颜色
  TextStyle? get textStyle => Theme.of(this).textTheme.bodyMedium;

  //系统加粗字体颜色
  TextStyle? get textBoldStyle => Theme.of(this).textTheme.bodyLarge;

  //导航栏高度,AppBarHeight
  double get appBarHeight => kToolbarHeight;

  ///获得控件正下方的坐标：
  Offset? location({bool hasOffset = true}) {
    final RenderBox? renderBox = findRenderObject() as RenderBox?;
    final Offset? offset =
        renderBox?.localToGlobal(hasOffset ? Offset(renderBox.size.width, renderBox.size.height) : Offset.zero);
    return offset;
  }

  void setSystemUiOverlayStyle(SystemUiOverlayStyle style) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(style);
    }
  }

  void setDarkStyle() {
    setSystemUiOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
  }
}
