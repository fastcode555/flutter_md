import 'package:characters/src/characters_impl.dart' as impl;
import 'package:flutter/material.dart';

/// @date 16/8/22
/// describe:
class Utils {
  Utils._();

  static List<String?> ignoreIds = [];

  static void addIgnore(String? id) {
    if (id != null && id.isNotEmpty && !ignoreIds.contains(id)) {
      ignoreIds.add(id);
    }
  }

  //常用上标 ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁺ ⁻ ⁼ ⁽ ⁾ ⁿ º ˙
  //
  // 常用下标₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ₊ ₋ ₌ ₍ ₎ ₐ ₑ ₒ ₓ ₔ
  //
  // 中文上标 ㆒㆓㆔㆕㆖㆗㆘㆙㆚㆛㆜㆝㆞㆟
  //
  // 更多上标 ᵃ ᵇ ᶜ ᵈ ᵉ ᵍ ʰ ⁱ ʲ ᵏ ˡ ᵐ ⁿ ᵒ ᵖ ᵒ ʳ ˢ ᵗ ᵘ ᵛ ʷ ˣ ʸ ᙆ ᴬ ᴮ ᒼ ᴰ ᴱ ᴳ ᴴ ᴵ ᴶ ᴷ ᴸ ᴹ ᴺ ᴼ ᴾ ᴼ̴ ᴿ ˢ ᵀ ᵁ ᵂ ˣ ᵞ ᙆ ˀ ˁ ˤ ʱ ʴ ʵ ʶ ˠ ᴭ ᴯ ᴲ ᴻ ᴽ ᵄ ᵅ ᵆ ᵊ ᵋ ᵌ ᵑ ᵓ ᵚ ᵝ ᵞ ᵟ ᵠ ᵡ ᵎ ᵔ ᵕ ᵙ ᵜ ᶛ ᶜ ᶝ ᶞ ᶟ ᶡ ᶣ ᶤ ᶥ ᶦ ᶧ ᶨ ᶩ ᶪ ᶫ ᶬ ᶭ ᶮ ᶯ ᶰ ᶱ ᶲ ᶳ ᶴ ᶵ ᶶ ᶷ ᶸ ᶹ ᶺ ᶼ ᶽ ᶾ ᶿ ჼ ᒃ ᕻ ᑦ ᒄ ᕪ ᑋ ᑊ ᔿ ᐢ ᣕ ᐤ ᣖ ᣴ ᣗ ᔆ ᙚ ᐡ ᘁ ᐜ ᕽ ᙆ ᙇ ᒼ ᣳ ᒢ ᒻ ᔿ ᐤ ᣖ ᣵ ᙚ ᐪ ᓑ ᘁ ᐜ ᕽ ᙆ ᙇ ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁺ ⁻ ⁼ ˂ ˃ ⁽ ⁾ ˙ * º
  //
  // 更多下标 ₐ ₔ ₑ ᵢ ₒ ᵣ ᵤ ᵥ ₓ ᙮ ᵤ ᵩ ᵦ ˪ ៳ ៷ ₒ ᵨ ៴ ᵤ ᵪ ᵧ
  static const List<String> bottomNums = <String>['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
  static const List<String> topNums = <String>['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];

  ///获取下标数字
  static String getBottomNum(String textContent) {
    StringBuffer writer = StringBuffer();
    impl.StringCharacters chars = textContent.characters as impl.StringCharacters;
    for (int i = 0; i < chars.length; i++) {
      String value = chars.elementAt(i);
      try {
        int num = int.parse(value);
        writer.write(bottomNums[num]);
      } catch (e) {
        print(e);
        writer.write(value);
      }
    }
    return writer.toString();
  }

  ///获取上标数字
  static String getTopNum(String textContent) {
    StringBuffer writer = StringBuffer();
    impl.StringCharacters chars = textContent.characters as impl.StringCharacters;
    for (int i = 0; i < chars.length; i++) {
      String value = chars.elementAt(i);
      try {
        int num = int.parse(value);
        writer.write(topNums[num]);
      } catch (e) {
        print(e);
        writer.write(value);
      }
    }
    return writer.toString();
  }

  static Map<String, Color> colors = {
    "red": Colors.red,
    "blue": Colors.blue,
    "brown": Colors.brown,
    "purple": Colors.purple,
    "orange": Colors.orange,
    "teal": Colors.teal,
    "green": Colors.green,
    "pink": Colors.pink,
    "lime": Colors.lime,
    "indigo": Colors.indigo,
    "cyan": Colors.cyan,
    "amber": Colors.amber,
    "yellow": Colors.yellow,
    "black": Colors.black,
    "white": Colors.white,
    "grey": Colors.grey,
  };

  static Color getColor(String color) {
    if (color.startsWith("#")) {
      return asColor(color);
    }
    return Utils.colors[color] ?? Colors.red;
  }

  static Color asColor(String hexColor) {
    try {
      if (hexColor.isEmpty) return Colors.amber;
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      hexColor = hexColor.replaceAll('0X', '');
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      print(e);
    }
    return Colors.amber;
  }
}
