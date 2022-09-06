import 'package:common/common.dart';
import 'package:flutter/material.dart';

class CommonConfigImp extends CommonConfig {
  @override
  Color get hintColor => Colors.grey;

  @override
  Color get mainTextColor => Colors.black;

  @override
  void add2Panel(String url) {}

  @override
  BuildContext get context => Get.context!;

  @override
  void showConfirmDialog(
      {String title = '',
      String content = '',
      String? leftTitle,
      String? rightTitle,
      VoidCallback? leftCallBack,
      VoidCallback? rightCallBack}) {}
}
