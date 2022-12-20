import 'package:flutter/foundation.dart';

class CoreConfig {
  static bool debug = kDebugMode;
  static const bool kReleaseMode = bool.fromEnvironment('dart.vm.product', defaultValue: false);
  static const bool kProfileMode = bool.fromEnvironment('dart.vm.profile', defaultValue: false);
  static String version = "1.0.0";
  static String versionCode = "1.0.0(80)";
  static int buildNumber = 0;
  static String os = "android";
  static String? osVersion = "";
  static String? deviceName = "";
  static String? deviceType = "";

  static String boundId = "com.awesome";
  static String lang = "zh-Hans";
  static String systemVersion = "";
}
