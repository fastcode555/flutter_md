import 'package:common/common.dart';
import 'package:flutter_md/ui/md_editor_page.dart';

class AppPages {
  static const initial = MdEditorPage.routeName;
  static final List<GetPage> routes = [
    _page(
      name: MdEditorPage.routeName,
      page: () => const MdEditorPage(),
    ),
  ];

  static final unknownRoute = _page(
    name: MdEditorPage.routeName,
    page: () => const MdEditorPage(),
  );

  static GetPage _page({
    required String name,
    required GetPageBuilder page,
    bool transparentRoute = false,
    Bindings? binding,
    Transition? transition,
    CustomTransition? customTransition,
  }) {
    if (transparentRoute) {
      return TransparentRoute(
        name: name,
        binding: binding,
        transition: transition ?? Transition.downToUp,
        page: page,
      );
    }

    return GetPage(
      name: name,
      binding: binding,
      customTransition: customTransition,
      transition: transition ?? Transition.rightToLeft,
      page: page,
    );
  }
}
