import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'auto_complete_ex.dart';

/// @date 6/9/22
/// describe:
List<String> _options = [
  'int',
  'double',
  'String',
  'num',
  'void',
  'extends',
  'class',
  'Widget',
  'StatefulWidget',
  'StatelessWidget',
  'abstract',
  'BuildContext',
  '##',
  '###',
  '####',
  '#####',
  '######',
];

class AutoMdEditor extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxShowCount;
  final double itemHeight;
  final double hintWidth;
  final double hintHeight;
  final double padding;
  final TextStyle style;

  const AutoMdEditor({
    required this.controller,
    required this.focusNode,
    this.maxShowCount = 8,
    this.itemHeight = 40.0,
    this.hintWidth = 300,
    this.hintHeight = 300,
    this.padding = 16.0,
    this.style = const TextStyle(height: 1.1),
    Key? key,
  }) : super(key: key);

  @override
  _AutoMdEditorState createState() => _AutoMdEditorState();
}

class _AutoMdEditorState extends State<AutoMdEditor> {
  ///行高
  double _lineHeight = 0.0;

  ///面板的大小
  double _width = 0.0;

  String _tipText = "";

  @override
  void initState() {
    super.initState();
    _lineHeight = "\n".paintHeightWithTextStyle(widget.style);
    _width = widget.hintWidth - widget.padding * 2;
  }

  @override
  void didUpdateWidget(covariant AutoMdEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hintWidth != oldWidget.hintWidth || widget.padding != oldWidget.padding) {
      _width = widget.hintWidth - widget.padding * 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoCompleteEx<String>(
      onSelected: (s) {},
      textEditingController: widget.controller,
      focusNode: widget.focusNode,
      optionsViewBuilder: (_, onSelected, options) => _optionsViewBuilder(_, onSelected, options, context),
      optionsBuilder: _optionsBuilder,
      fieldViewBuilder: _fieldViewBuilder,
      offsetBuilder: _offsetBuilder,
    );
  }

  ///构建提示的文本
  Widget _optionsViewBuilder(_, onSelected, options, BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: _width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              height: (options.length > widget.maxShowCount ? widget.maxShowCount : options.length) * widget.itemHeight,
              child: MediaQuery.removePadding(
                context: context,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    String text = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        String content = widget.controller.text;
                        TextSelection selection = widget.controller.selection;
                        int start = selection.start;
                        String header = content.substring(0, start);
                        String tail = content.substring(start, content.length);
                        header = header.replaceRange(start - _tipText.length, start, text);
                        widget.controller.text = "$header$tail";
                        widget.controller.selection = createTextSelection(header);
                      },
                      child: Container(
                        height: widget.itemHeight,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(text),
                      ),
                    );
                  },
                  itemCount: options.length,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  ///获取符合筛选条件的备选项
  FutureOr<Iterable<String>> _optionsBuilder(TextEditingValue textEditingValue) {
    String text = textEditingValue.text;
    if (text.isEmpty || text.trim().isEmpty) return [];
    int start = widget.controller.selection.start;
    int end = widget.controller.selection.end;
    if (start != end) return [];
    text = text.substring(0, start);
    text = text.split("\n").last;
    if (text.contains(' ')) {
      text = text.split(' ').last;
    }
    if (text.isEmpty) return [];
    _tipText = text;
    return _options.where((e) => _filterValue(e, text)).toList();
  }

  ///创建的文本编辑框
  Widget _fieldViewBuilder(_, textEditingController, focusNode, onFieldSubmitted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: textEditingController,
        focusNode: focusNode,
        scrollPadding: EdgeInsets.zero,
        style: widget.style,
        maxLines: null,
        onSubmitted: (String value) => onFieldSubmitted(),
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }

  bool _filterValue(String element, String text) {
    return element != text && element.toLowerCase().startsWith(text.toLowerCase());
  }

  Offset _offsetBuilder() {
    String text = widget.controller.text;
    TextSelection selection = widget.controller.selection;
    int start = selection.start;
    int end = selection.end;
    if (start == end) {
      String tail = text.substring(end, text.length);
      double height = tail.paintHeightWithTextStyle(widget.style, maxWidth: _width);
      print("计算到高度$height");
      return Offset(
        widget.padding,
        height < _lineHeight ? 0 : -height + _lineHeight - ((tail.split('\n').length) * _lineHeight * 0.1),
      );
    }
    return Offset.zero;
  }

  ///创建选择到的最后的文本
  TextSelection createTextSelection(String content) {
    return TextSelection.fromPosition(
      TextPosition(affinity: TextAffinity.downstream, offset: content.length),
    );
  }
}
