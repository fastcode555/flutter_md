import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

/// @date 15/8/22
/// describe:
class LinkTapBuilder {
  final File? file;
  String dir = '';

  LinkTapBuilder(this.file) {
    dir = file?.parent.path ?? '';
  }

  void onTap(String text, String? href, String title) {
    if (href != null && href.isNotEmpty) {
      if (href.startsWith("http")) {
        launchUrlString(href);
      } else {}
    }
  }
}
