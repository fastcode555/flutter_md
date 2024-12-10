import 'dart:ui';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/themes.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';
import 'package:get_storage/get_storage.dart';

import 'app_pages.dart';
import 'res/translation_service.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertino,
          unknownRoute: AppPages.unknownRoute,
          locale: LanguageUtil.initLanguage().toLocale(),
          theme: Themes.theme(),
          darkTheme: Themes.theme(true),
          translations: TranslationService(),
          builder: (ctx, child) {
            return OKToast(
              backgroundColor: Colors.black54,
              textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              radius: 20.0,
              position: ToastPosition.bottom,
              child: GestureDetector(
                child: child,
                onTap: () {
                  var currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, PointerDeviceKind.mouse};
}
