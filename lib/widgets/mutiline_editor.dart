import 'dart:async';
import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../utils/edit_utils.dart';

/// @date 12/9/22
/// describe: 编辑页面
class MultilineEditor extends StatefulWidget {
  final File? file;
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? content;
  final ScrollController? scrollController;
  final bool autoEmpty;
  final TextStyle? style;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String?>? validator;
  final int? maxLines;

  const MultilineEditor({
    this.file,
    this.controller,
    this.scrollController,
    this.autofocus = false,
    this.focusNode,
    this.content,
    this.style,
    this.onFieldSubmitted,
    this.validator,
    this.autoEmpty = false,
    this.maxLines,
    Key? key,
  }) : super(key: key);

  @override
  _MultilineEditorState createState() => _MultilineEditorState();
}

class _MultilineEditorState extends State<MultilineEditor> with AutomaticKeepAliveClientMixin {
  late TextEditingController _controller;

  Timer? _timer;
  String _lastData = '';
  Timer? _delayDealTimer;
  bool _isIncrease = true;

  //用来判断输入是增加还是减少
  int _lastSize = -1;

  ///文件的类型
  String _type = '';

  @override
  void initState() {
    super.initState();
    _type = widget.file?.type ?? 'md';
    _controller = widget.controller ?? TextEditingController();

    //读取到数据
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String content = widget.content ?? widget.file?.readAsStringSync() ?? '';
      if (content.isNotEmpty) {
        _controller.text = content;
      }
      _lastData = _controller.text;
    });

    _controller.addListener(() {
      _isIncrease = _lastSize < _controller.text.length;
      _lastSize = _controller.text.length;
    });

    //开启自动保存文本的功能
    _timer = Timer.periodic(
      const Duration(milliseconds: 5000),
      (timer) {
        if (_controller.text != _lastData) {
          _lastData = _controller.text;
          widget.file?.writeAsString(_lastData);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextFormField(
      autofocus: widget.autofocus,
      scrollPadding: EdgeInsets.zero,
      autocorrect: false,
      scrollController: widget.scrollController,
      keyboardType: TextInputType.multiline,
      controller: _controller,
      style: widget.style,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      validator: widget.validator,
      onFieldSubmitted: (text) {
        widget.onFieldSubmitted?.call(text);
      },
      onChanged: (value) {
        _delayDealTimer?.cancel();
        _delayDealTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
          _processSymbols();
          _delayDealTimer?.cancel();
          _delayDealTimer = null;
        });
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
    );
  }

  @override
  void dispose() {
    widget.file?.writeAsString(_controller.text);
    super.dispose();
    _timer?.cancel();
  }

  @override
  bool get wantKeepAlive => true;

  ///处理 符号*数量的问题
  void _processSymbols() {
    int start = _controller.selection.start;
    int end = _controller.selection.end;
    String header = _controller.text.substring(0, end);
    String tail = _controller.text.substring(end, _controller.text.length);

    if (start == end) {
      List<String> results = header.split("\n");
      List<String> tailResults = tail.split("\n");
      String line = results.last + tailResults.first;
      String lastContent = results.last;
      if (lastContent.isEmpty && results.length >= 2) {
        //根据上一行的内容，自动在换行后添加类似内容
        _addSameLastLine(header, tail, results);
      } else if (_type == 'md' && results.last.endsWith('```')) {
        String newHeader = '$header\n';
        String newTail = '```\n$tail';
        _controller.text = "$newHeader\n$newTail";
        _controller.selection = EditUtils.createTextSelection(newHeader);
      } else if (_type == 'md' && results.last.endsWith('`')) {
        int count = EditUtils.specialRegex.allMatches(line).length;
        //不为整数，说明没有成对出现，自动补足
        if (count % 2 != 0) {
          _controller.text = "$header`$tail";
          _controller.selection = EditUtils.createTextSelection(header);
        }
      } else if (lastContent.length >= 3) {
        _addSameAtThisLine(header, tail, results);
      }
    }
  }

  ///添加数据的计算结果
  void _addCaculateResult(String line, String header, String tail) {
    String content = EditUtils.getMatchMath(line);
    //计算这个数学公式的结果
    String result = EditUtils.caculateMath2(content);
    _controller.text = "$header$result$tail";
    _controller.selection = EditUtils.createTextSelection("$header$result");
  }

  ///添加相同字符的功能
  void _addSameCharacter(List<String> results, String header, String tail) {
    String line = results.last;
    bool isMatch = EditUtils.matchAiSymbol(line);
    if (isMatch) {
      String matchContent = EditUtils.getMatchAiSymbol(line).trim();
      List<String> results = matchContent.split("*");
      if (results.length == 2) {
        String symbol = results[0];
        int count = results[1].secureInt;
        //如果是数字，不进行处理
        if (symbol.trim() == "0" || symbol.secureNum > 0) return;
        header = header.replaceAll(matchContent, symbol * count);
        _controller.text = "$header$tail";
        _controller.selection = EditUtils.createTextSelection(header);
      }
    }
  }

  ///根据上一行的内容，在换行后添加相似的内容
  void _addSameLastLine(String header, String tail, List<String> results) {
    String currentLine = tail.split('\n').first.trim();
    if (!_isIncrease && currentLine.isEmpty) return;
    String lastSecondContent = results[results.length - 2];
    if (EditUtils.matchMath(lastSecondContent)) return;
    if (EditUtils.matchSymbolRegex.hasMatch(lastSecondContent)) {
      //处理这种类似带括号的数(1).
      String? startContent = EditUtils.matchSymbolRegex.firstMatch(lastSecondContent)?.group(0);
      String numberStr = EditUtils.getNumber(startContent ?? '');
      if (numberStr.isNotEmpty) {
        int newNum = numberStr.secureInt + 1;
        String newLineStart = startContent!.replaceAll(numberStr, "$newNum");
        _controller.text = "$header$newLineStart$tail";
        _controller.selection = EditUtils.createTextSelection("$header$newLineStart");
      }
    } else if (EditUtils.cnDigitalRegex.hasMatch(lastSecondContent)) {
      //判断上一行采用的是什么特殊符号开头
      String? startContent = EditUtils.cnDigitalRegex.firstMatch(lastSecondContent)?.group(0);
      if (startContent != null && startContent.isNotEmpty) {
        //匹配出中文数字的部分
        String? cnNumber = EditUtils.cnDigital.firstMatch(startContent)?.group(0);
        if (cnNumber == null || cnNumber.isEmpty) return;
        String newCnNumber = EditUtils.addNum(cnNumber);
        startContent = startContent.replaceAll(cnNumber, newCnNumber);
        _controller.text = "$header$startContent$tail";
        _controller.selection = EditUtils.createTextSelection("$header$startContent");
      }
    } else if (EditUtils.specialDigitalRegex.hasMatch(lastSecondContent)) {
      //判断上一行采用的是什么特殊符号开头
      String? startContent = EditUtils.specialDigitalRegex.firstMatch(lastSecondContent)?.group(0);
      if (startContent != null && startContent.isNotEmpty) {
        //匹配出中文数字的部分
        String? cnNumber = EditUtils.specialDigital.firstMatch(startContent)?.group(0);
        if (cnNumber == null || cnNumber.isEmpty) return;
        String newCnNumber = EditUtils.addSpecialNum(cnNumber);
        startContent = startContent.replaceAll(cnNumber, newCnNumber);
        _controller.text = "$header$startContent$tail";
        _controller.selection = EditUtils.createTextSelection("$header$startContent");
      }
    } else if (EditUtils.specialDigitalRegex2.hasMatch(lastSecondContent)) {
      //判断上一行采用的是什么特殊符号开头
      String? startContent = EditUtils.specialDigitalRegex2.firstMatch(lastSecondContent)?.group(0);
      if (startContent != null && startContent.isNotEmpty) {
        //匹配出中文数字的部分
        String? cnNumber = EditUtils.specialDigital2.firstMatch(startContent)?.group(0);
        if (cnNumber == null || cnNumber.isEmpty) return;
        String newCnNumber = EditUtils.addSpecialNum2(cnNumber);
        startContent = startContent.replaceAll(cnNumber, newCnNumber);
        _controller.text = "$header$startContent$tail";
        _controller.selection = EditUtils.createTextSelection("$header$startContent");
      }
    } else if (EditUtils.specialDigitalRegex3.hasMatch(lastSecondContent)) {
      //判断上一行采用的是什么特殊符号开头
      String? startContent = EditUtils.specialDigitalRegex3.firstMatch(lastSecondContent)?.group(0);
      if (startContent != null && startContent.isNotEmpty) {
        String? cnNumber = EditUtils.specialDigital3.firstMatch(startContent)?.group(0);
        if (cnNumber == null || cnNumber.isEmpty) return;
        String newCnNumber = EditUtils.addSpecialNum3(cnNumber);
        startContent = startContent.replaceAll(cnNumber, newCnNumber);
        _controller.text = "$header$startContent$tail";
        _controller.selection = EditUtils.createTextSelection("$header$startContent");
      }
    } else if (EditUtils.specialDigitalRegex4.hasMatch(lastSecondContent)) {
      //判断上一行采用的是什么特殊符号开头
      String? startContent = EditUtils.specialDigitalRegex4.firstMatch(lastSecondContent)?.group(0);
      if (startContent != null && startContent.isNotEmpty) {
        String? cnNumber = EditUtils.specialDigital4.firstMatch(startContent)?.group(0);
        if (cnNumber == null || cnNumber.isEmpty) return;
        String newCnNumber = EditUtils.addSpecialNum4(cnNumber);
        startContent = startContent.replaceAll(cnNumber, newCnNumber);
        _controller.text = "$header$startContent$tail";
        _controller.selection = EditUtils.createTextSelection("$header$startContent");
      }
    } else if (EditUtils.matchGanRegex.hasMatch(lastSecondContent)) {
      //判断上一行采用的是什么特殊符号开头
      String? startContent = EditUtils.matchGanRegex.firstMatch(lastSecondContent)?.group(0);
      if (startContent != null && _isIncrease) {
        _controller.text = "$header$startContent$tail";
        _controller.selection = EditUtils.createTextSelection("$header$startContent");
      }
    } else if (_type == 'md' && EditUtils.tableRegex.hasMatch(lastSecondContent)) {
      //正则匹配markdown文件的表格有多个'|',换行后自动添加
      bool isStart = lastSecondContent.startsWith("|");
      int count = EditUtils.tableRegex.allMatches(lastSecondContent).length;
      String newHeader = isStart ? "$header|" : header;
      String newTail = isStart ? "${"|" * (count - 1)}$tail" : "${'|' * count}$tail";
      _controller.text = '$newHeader$newTail';
      _controller.selection = EditUtils.createTextSelection(newHeader);
    } else if (_isIncrease && widget.autoEmpty) {
      //换行，增加空格的功能
      header = '$header\n　　';
      _controller.text = '$header$tail';
      _controller.selection = EditUtils.createTextSelection(header);
    }
  }

  ///在本行根据规则添加相似的内容
  void _addSameAtThisLine(String header, String tail, List<String> results) {
    String line = results.last;
    bool isMatch = EditUtils.matchMath(line);
    bool hasResult = EditUtils.matchMathResult(line);
    if (isMatch && !hasResult) {
      _addCaculateResult(line, header, tail);
    } else if (line.endsWith(">") && EditUtils.tagRegex.hasMatch(line)) {
      //匹配到了标签
      String? matchContent = EditUtils.tagRegex.allMatches(line).last.group(0);
      if (matchContent != null && !matchContent.startsWith("</") && !matchContent.endsWith("/>")) {
        String tagName = matchContent.replaceAll("<", '').replaceAll(">", '').trim();
        String newHeader = "$header</$tagName>";
        _controller.text = '$newHeader$tail';
        _controller.selection = EditUtils.createTextSelection(header);
      }
    } else {
      // 符号*20，这种，用于批量解决数量的问题
      _addSameCharacter(results, header, tail);
    }
  }
}
