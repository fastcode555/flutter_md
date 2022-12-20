import 'package:common/common.dart';
import 'package:flutter_md/ui/md_editor_page.dart';

import 'ui/main_page.dart';

class AppPages {
  static const initial = MainPage.routeName;
  static final List<GetPage> routes = [
    _page(
      name: MdEditorPage.routeName,
      page: () => const MdEditorPage(),
    ),
    _page(
      name: MainPage.routeName,
      page: () => const MainPage(),
    ),
  ];

  static final unknownRoute = _page(
    name: MainPage.routeName,
    page: () => const MainPage(),
  );

  static GetPage _page({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    Transition? transition,
    CustomTransition? customTransition,
  }) {
    return GetPage(
      name: name,
      binding: binding,
      customTransition: customTransition,
      transition: transition ?? Transition.rightToLeft,
      page: page,
    );
  }
}
