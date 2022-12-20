import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common.dart';

extension GetExt on GetInterface {
  ThemeMode? get themeMode => Get.rootController.themeMode;

  Future<T?>? offNamedUntilName<T>(String routeName, untilName, {dynamic arguments}) {
    return Get.offNamedUntil<T>(routeName, ModalRoute.withName(untilName), arguments: arguments);
  }

  void pop<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    Get.back(result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
  }

  void popUntil(String routeName) {
    Navigator.of(Get.context!).popUntil(ModalRoute.withName(routeName));
  }

  dismiss<T>([T? result]) {
    if (Get.isDialogOpen ?? false) {
      Get.back<T>(result: result);
    }
  }

  loading({
    String? tip,
    bool? canBack,
    Widget? widget,
    Color? barrierColor,
  }) {
    dismiss();
    Get.dialog(
      widget ?? const CupertinoActivityIndicator(),
      barrierColor: barrierColor,
    );
  }
}
