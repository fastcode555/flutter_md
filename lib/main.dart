import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/base/common_config_imp.dart';
import 'package:flutter_md/themes.dart';

import 'home_page.dart';

void main() {
  CommonConfig.init(CommonConfigImp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.theme(),
      home: const Material(child: HomePage()),
    );
  }
}
