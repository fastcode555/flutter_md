import 'dart:math';

import 'package:characters/characters.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// @date 13/9/22
/// describe:

class EditUtils {
  static const String _cnNumbers = "零一二三四五六七八九十";
  static const List<String> _cnIndexUnits = ["十", "百", "千", "万"];
  static final List<RegExp> _cnIndexUnitsRegex = [
    RegExp(r'[零一二三四五六七八九]*十'),
    RegExp(r'[零一二三四五六七八九]*百'),
    RegExp(r'[零一二三四五六七八九]*千'),
    RegExp(r'[零一二三四五六七八九]*万'),
  ];
  static const String _circleNumbers = "①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯";

  static const String _circleNumbers2 = '❶❷❸❹❺❻❼❽❾❿';
  static const List<String> _circleNumbers3 = [
    "Ⅰ",
    "Ⅱ",
    "Ⅲ",
    "Ⅳ",
    "Ⅴ",
    "Ⅵ",
    "Ⅶ",
    "Ⅷ",
    'Ⅸ',
    'Ⅹ',
    'XI',
    'XII',
    'XIII',
    'XIV',
    'XV',
    'XVI'
  ];
  static const List<String> _circleNumbers4 = [
    "ⅰ",
    "ⅱ",
    "ⅲ",
    "ⅳ",
    "ⅴ",
    "ⅵ",
    "ⅶ",
    "ⅷ",
    'ⅸ',
    'ⅹ',
    'ⅹⅰ',
    'ⅹⅱ',
    'ⅹⅲ',
    'ⅹⅰⅴ',
    'ⅹⅴ',
    'ⅹⅴⅰ'
  ];

  EditUtils._();

  ///正则匹配表格形式，自动添加表格
  static final RegExp tableRegex = RegExp(r'[|]{1}');

  ///匹配特殊符号
  static final RegExp specialRegex = RegExp(r'[`]{1}');

  static final RegExp _numberRegex = RegExp(r'\d+');

  ///匹配(任何符号)*16，例如 -*5，期望，意思是打印五个-字符，编辑器自动变为 -----
  static final RegExp _regexAutoFillSymbol = RegExp(r'[^0-9]\*[0-9]{1,500}');

  ///匹配数学公式
  static final RegExp _mathRegex = RegExp(r"^[（）\(\)0-9.\*\+-\/^]*=");

  ///判断公式是不是含有结果
  static final RegExp _hasMathResult = RegExp(r'=[0-9.\-]{1,100}');

  ///主要是用于md页面，输入 -，下一行需要自动换行
  static final RegExp matchGanRegex = RegExp(r'^[ 　]*[-=^$#@!?/<>+|\\~%&*]{1,50}[ ]*');

  ///匹配类似(1).1).等这种括号开头的
  static final RegExp matchSymbolRegex = RegExp(r'^[ 　#]*[-\(\[{\【\「〖«\《\〈\『\（ ]*\d+[\)\]}\】\」»〗\》\〉\』\）]*[.,，。、]*');

  ///中文的序号匹配
  static final RegExp cnDigitalRegex =
      RegExp(r'^[ 　#]*[\(\[{\【\「〖«\《\〈\『\（]*[零一二三四五六七八九十百千]{1,30}[\)\]}\】\」»〗\》\〉\』\）]*[.,，。、]*');
  static final RegExp cnDigital = RegExp(r'[零一二三四五六七八九十百千]{1,30}');

  static final RegExp specialDigitalRegex =
      RegExp(r'^[ 　#]*[- \(\[{\【\「〖«\《\〈\『\（]*[①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮]{1}[\)\]}\】\」»〗\》\〉\』\）]*[.,，。、]*');
  static final RegExp specialDigital = RegExp(r'[①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮]{1}');
  static final RegExp specialDigitalRegex2 =
      RegExp(r'^[ 　#]*[- \(\[{\【\「〖«\《\〈\『\（]*[❶❷❸❹❺❻❼❽❾]{1}[\)\]}\】\」»〗\》\〉\』\）]*[.,，。、]*');
  static final RegExp specialDigital2 = RegExp(r'[❶❷❸❹❺❻❼❽❾]{1}');

  static final RegExp specialDigitalRegex3 =
      RegExp(r'^[ 　#]*[- \(\[{\【\「〖«\《\〈\『\（]*[ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩXIXIIXIIIXIVXVXVI]{1,4}[\)\]}\】\」»〗\》\〉\』\）]*[.,，。、]*');
  static final RegExp specialDigital3 = RegExp(r'[ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩXIXIIXIIIXIVXVXVI]{1,4}');

  static final RegExp specialDigitalRegex4 =
      RegExp(r'^[ 　#]*[- \(\[{\【\「〖«\《\〈\『\（]*[ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⅹⅰⅹⅱⅹⅲⅹⅰⅴⅹⅴⅹⅴⅰ]{1,4}[\)\]}\】\」»〗\》\〉\』\）]*[.,，。、]*');
  static final RegExp specialDigital4 = RegExp(r'[ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⅹⅰⅹⅱⅹⅲⅹⅰⅴⅹⅴⅹⅴⅰ]{1,4}');

  ///使用正则匹配html或者xml的标签，是能够自动添加尾标签
  static final RegExp tagRegex = RegExp(r'<.*?[>| ]');

  ///判断是否满足数学公式
  static bool matchMath(String content) {
    return _mathRegex.hasMatch(content);
  }

  ///判断是否满足数学公式
  static bool matchMathResult(String content) {
    return _hasMathResult.hasMatch(content);
  }

  ///获取匹配到的数学公式
  static String getMatchMath(String content) {
    RegExpMatch? match = _mathRegex.firstMatch(content);
    return match?.group(0) ?? '';
  }

  ///判断是否是数字开头的换行，需要匹配这样，提高效率
  static bool matchAiSymbol(String content) {
    return _regexAutoFillSymbol.hasMatch(content);
  }

  ///获取匹配到的只能符号
  static String getMatchAiSymbol(String content) {
    RegExpMatch? match = _regexAutoFillSymbol.firstMatch(content);
    return match?.group(0) ?? '';
  }

  ///获取匹配到的数字
  static String getNumber(String content) {
    return _numberRegex.firstMatch(content)?.group(0) ?? '';
  }

  ///创建选择到的最后的文本
  static TextSelection createTextSelection(String content) {
    return TextSelection.fromPosition(
      TextPosition(affinity: TextAffinity.downstream, offset: content.length),
    );
  }

  ///根据给定的位置创建选中位置
  static TextSelection lengthSelection(int start) {
    return TextSelection.fromPosition(
      TextPosition(affinity: TextAffinity.downstream, offset: start),
    );
  }

  ///计算这个数学公式的结果
  static String singleMath(String content) {
    if (content.contains("=")) {
      content = content.replaceAll("=", '');
      content = content.replaceAll("+-", '-');
    }
    RegExp regex;
    if (content.contains('^')) {
      regex = RegExp(r'[0-9.]*\^[0-9.]*');
      var matchs = regex.allMatches(content);
      for (RegExpMatch match in matchs) {
        String? matchString = match.group(0);
        List<String>? splits = matchString?.split("^");
        if (splits != null) {
          String value = pow(splits[0].secureNum, splits[1].secureNum).toString();
          content = content.replaceAll(matchString ?? '', value);
        }
      }
      return singleMath(content);
    }
    int hasMultiply = content.indexOf("*");
    int hasDivide = content.indexOf("/");
    if (hasMultiply < hasDivide && hasMultiply > 0 || hasMultiply > 0 && hasDivide < 0) {
      regex = RegExp(r'[0-9.]*\*[0-9.]*');
      String? matchString = regex.firstMatch(content)?.group(0);
      List<String>? splits = matchString?.split("*");
      if (splits != null) {
        String value = (splits[0].secureNum * splits[1].secureNum).toString();
        content = content.replaceAll(matchString ?? '', value);
        return singleMath(content);
      }
    } else if (hasDivide > 0) {
      regex = RegExp(r'[0-9.]*\/[0-9.]*');
      String? matchString = regex.firstMatch(content)?.group(0);
      List<String>? splits = matchString?.split("/");
      if (splits != null) {
        String value = (splits[0].secureNum / splits[1].secureNum).toString();
        content = content.replaceAll(matchString ?? '', value);
        return singleMath(content);
      }
    }

    int hasAdd = content.indexOf("+");
    int hasReduce = content.indexOf("-");
    if (hasAdd < hasReduce && hasAdd > 0 || hasAdd > 0 && hasReduce < 0) {
      regex = RegExp(r'[0-9.]*\+[0-9.]*');
      String? matchString = regex.firstMatch(content)?.group(0);
      List<String>? splits = matchString?.split("+");
      if (splits != null) {
        String value = (splits[0].secureNum + splits[1].secureNum).toString();
        content = content.replaceAll(matchString ?? '', value);
        return singleMath(content);
      }
    } else if (hasReduce > 0) {
      regex = RegExp(r'[0-9.]*\-[0-9.]*');
      String? matchString = regex.firstMatch(content)?.group(0);
      List<String>? splits = matchString?.split("-");
      if (splits != null) {
        String value = (splits[0].secureNum - splits[1].secureNum).toString();
        content = content.replaceAll(matchString ?? '', value);
        return singleMath(content);
      }
    }
    return content;
  }

  static String caculateMath2(String content) {
    //替换掉中文的特舒符号
    if (content.contains("（") || content.contains('）')) {
      content = content.replaceAll('（', '(').replaceAll("）", ')').replaceAll(" ", "").trim();
    }

    if (content.contains("(")) {
      int start = content.lastIndexOf("(");
      String tail = content.substring(start, content.length);
      int end = tail.indexOf(')');
      String single = tail.substring(1, end);
      String result = EditUtils.singleMath(single);
      content = content.replaceAll('($single)', result);
      return caculateMath2(content);
    }
    print(content);
    content = singleMath(content);
    return content;
  }

  ///处理特舒符号类型
  static String addSpecialNum(String cnNumber, {int step = 1}) {
    cnNumber = cnNumber.trim();
    int index = _circleNumbers.indexOf(cnNumber) + 1;
    if (index < _circleNumbers.length) {
      return _circleNumbers[index];
    }
    return '';
  }

  static String addSpecialNum2(String cnNumber, {int step = 1}) {
    cnNumber = cnNumber.trim();
    int index = _circleNumbers2.indexOf(cnNumber) + 1;
    if (index < _circleNumbers2.length) {
      return _circleNumbers2[index];
    }
    return '';
  }

  static String addSpecialNum3(String cnNumber, {int step = 1}) {
    cnNumber = cnNumber.trim();
    int index = _circleNumbers3.indexOf(cnNumber) + 1;
    if (index < _circleNumbers3.length) {
      return _circleNumbers3[index];
    }
    return '';
  }

  static String addSpecialNum4(String cnNumber, {int step = 1}) {
    cnNumber = cnNumber.trim();
    int index = _circleNumbers4.indexOf(cnNumber) + 1;
    if (index < _circleNumbers4.length) {
      return _circleNumbers4[index];
    }
    return '';
  }

  //递增数字
  static String addNum(String cnNumber, {int step = 1}) {
    int value = _cnNum2Number(cnNumber) + step;
    return _num2CnNumber(value);
  }

  ///阿拉伯数字转中文数字
  static String _num2CnNumber(int value) {
    String number = '$value';
    List<String> nums = number.characters.toList().reversed.toList();
    String cnNumber = '';
    if (value < 10) return _cnNumbers[value];

    for (int i = 0; i < nums.length; i++) {
      int num = nums[i].secureInt;
      String cnDig = _cnNumbers[num];
      if (i == 0 && num != 0) {
        cnNumber = cnDig;
      } else if (i == 1) {
        if (num == 1 && value < 20) {
          cnNumber = "十$cnNumber";
        } else {
          cnNumber = "$cnDig${num != 0 ? '十' : ''}$cnNumber";
        }
      } else if (i == 2) {
        cnNumber = "$cnDig${num != 0 ? '百' : ''}$cnNumber";
      } else if (i == 3) {
        cnNumber = "$cnDig千$cnNumber";
      }
    }
    cnNumber = _replaceEndZero(cnNumber);
    return cnNumber;
  }

  ///替换掉末尾的零
  static _replaceEndZero(String cnNumber) {
    if (cnNumber.endsWith("零")) {
      cnNumber = cnNumber.substring(0, cnNumber.length - 1);
      return _replaceEndZero(cnNumber);
    }
    if (cnNumber.contains("零零")) {
      cnNumber = cnNumber.replaceAll("零零", "零");
      return _replaceEndZero(cnNumber);
    }
    return cnNumber;
  }

  ///中文数字转阿拉伯数字
  static int _cnNum2Number(String cnNumber) {
    cnNumber = cnNumber.trim();
    if (cnNumber.length == 1) {
      return _cnNumbers.indexOf(cnNumber);
    }
    int total = 0;
    for (int i = 0; i < _cnIndexUnitsRegex.length; i++) {
      RegExp regex = _cnIndexUnitsRegex[i];
      String unit = _cnIndexUnits[i];
      String? value = regex.firstMatch(cnNumber)?.group(0)?.replaceAll(unit, '').replaceAll("零", "").trim();
      if (cnNumber.startsWith("十") && cnNumber.length == 2) {
        total = 10;
      } else if (value != null) {
        total += _cnNumbers.indexOf(value) * (pow(10, i + 1).toInt());
      }
    }
    if (!_endWithUnit(cnNumber)) {
      total += _cnNumbers.indexOf(cnNumber[cnNumber.length - 1]);
    }
    return total;
  }

  static bool _endWithUnit(String content) {
    for (String unit in _cnIndexUnits) {
      if (content.endsWith(unit)) {
        return true;
      }
    }
    return false;
  }
}
