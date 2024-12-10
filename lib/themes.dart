import 'package:flutter/material.dart';

const String _key = 'theme_color_key';
const String _bgKey = 'theme_color_bg_key';

class Themes {
  ///创建主题颜色
  static ThemeData theme([bool isDark = false]) {
    var _theme = ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
    Color themeColor = Colors.red;

    return _theme.copyWith(
      primaryColor: themeColor,
      primaryColorLight: themeColor,
      primaryColorDark: themeColor,
      inputDecorationTheme: InputDecorationTheme(
        focusColor: themeColor,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor)),
      ),
      dividerColor: themeColor,
      dividerTheme: const DividerThemeData(
        color: Colors.grey, // 设置全局 Divider 的颜色
        thickness: 1.0,     // 设置 Divider 的厚度
        space: 16.0,        // 设置 Divider 上下的间距
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconColor: themeColor,
          textStyle: TextStyle(color: themeColor),
        ),
      ),
      iconTheme: IconThemeData(color: themeColor),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: themeColor.withOpacity(0.5),
        cursorColor: themeColor,
        selectionHandleColor: themeColor.withOpacity(0.5),
      ),
      splashColor: themeColor.withOpacity(0.3),
      highlightColor: themeColor.withOpacity(0.1),
      hoverColor: themeColor.withOpacity(0.1),
      platform: TargetPlatform.iOS,
      indicatorColor: themeColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: themeColor,
      ),
      colorScheme: ColorScheme.light(
        primary: themeColor,
        secondary: themeColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(themeColor),
        ),
      ),
    );
  }
}
