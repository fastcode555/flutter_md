import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../model/tip_model.dart';
import '../utils/edit_utils.dart';
import 'auto_complete_ex.dart' as auto;

/// @date 6/9/22
/// describe:
class AutoCompleteEditor extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxShowCount;
  final double itemHeight;
  final double hintWidth;
  final double hintHeight;
  final double padding;
  final TextStyle style;

  ///这个就是展示的选项了
  final List<TipModel> options;
  final auto.AutocompleteFieldViewBuilder? fieldViewBuilder;
  final ValueNotifier<int> highlightedOptionIndex;

  const AutoCompleteEditor({
    required this.controller,
    required this.focusNode,
    this.maxShowCount = 8,
    this.itemHeight = 40.0,
    this.hintWidth = 300,
    this.hintHeight = 300,
    this.padding = 16.0,
    this.options = const [],
    this.fieldViewBuilder,
    required this.highlightedOptionIndex,
    this.style = const TextStyle(height: 1.1),
    Key? key,
  }) : super(key: key);

  @override
  _AutoCompleteEditorState createState() => _AutoCompleteEditorState();
}

class _AutoCompleteEditorState extends State<AutoCompleteEditor> {
  ///行高
  double _lineHeight = 0.0;

  ///面板的大小
  double _width = 0.0;

  ///提示选项生成的依据
  String _tipText = "";

  ///筛选到的选项数量
  int _optionCount = 0;

  @override
  void initState() {
    super.initState();
    _lineHeight = "\n".paintHeightWithTextStyle(widget.style);
    _width = widget.hintWidth - widget.padding * 2;
  }

  @override
  void didUpdateWidget(covariant AutoCompleteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hintWidth != oldWidget.hintWidth || widget.padding != oldWidget.padding) {
      _width = widget.hintWidth - widget.padding * 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return auto.AutoCompleteEx<TipModel>(
      onSelected: _onSelected,
      textEditingController: widget.controller,
      focusNode: widget.focusNode,
      highlightedOptionIndex: widget.highlightedOptionIndex,
      optionsViewBuilder: (_, onSelected, options) => _optionsViewBuilder(_, onSelected, options, context),
      optionsBuilder: _optionsBuilder,
      fieldViewBuilder: widget.fieldViewBuilder ?? _fieldViewBuilder,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.primaryColor),
              ),
              height: (options.length > widget.maxShowCount ? widget.maxShowCount : options.length) * widget.itemHeight,
              child: MediaQuery.removePadding(
                context: context,
                child: ValueListenableBuilder<int>(
                  valueListenable: widget.highlightedOptionIndex,
                  builder: (_, index, __) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        TipModel tipModel = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            _onSelected(tipModel);
                          },
                          child: _buildItem(tipModel, index, context),
                        );
                      },
                      itemCount: options.length,
                    );
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  ///获取符合筛选条件的备选项
  FutureOr<Iterable<TipModel>> _optionsBuilder(TextEditingValue textEditingValue) {
    String text = textEditingValue.text;
    if (text.isEmpty || text.trim().isEmpty) return [];
    int start = widget.controller.selection.start;
    int end = widget.controller.selection.end;
    if (start != end || start < 0) return [];
    String line = text.substring(0, start).split('\n').last + text.substring(start, text.length).split("\n").first;

    text = text.substring(0, start);
    text = text.split("\n").last;
    if (text.contains(' ')) {
      text = text.split(' ').last;
    }
    if (text.isEmpty) return [];
    _tipText = text;
    final list = widget.options.where((e) => _filterValue(e, text, line));
    _optionCount = list.length;
    return list.toList();
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

  bool _filterValue(TipModel element, String text, String line) {
    if (line.contains(element.template!)) return false;
    return element.template != text && element.template!.toLowerCase().startsWith(text.toLowerCase()) ||
        (element.keyword != null && element.keyword!.isNotEmpty && element.keyword!.startsWith(text.toLowerCase()));
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

  ///创建Item
  Widget _buildItem(TipModel tipModel, int index, BuildContext context) {
    int selectIndex = widget.highlightedOptionIndex.value;
    return Container(
      height: widget.itemHeight,
      alignment: Alignment.centerLeft,
      color: index == selectIndex ? context.primaryColor.withOpacity(0.5) : null,
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Row(
        children: [
          Text(
            tipModel.template!.startsWith(_tipText) ? tipModel.template! : '${tipModel.keyword!}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (!tipModel.template!.startsWith(_tipText))
            Text(
              '(${tipModel.template?.trim()})',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold),
            ),
          Expanded(
            child: Text(
              tipModel.desc ?? '',
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelected(TipModel tipModel) {
    String content = widget.controller.text;
    TextSelection selection = widget.controller.selection;
    int start = selection.start;
    String header = content.substring(0, start);
    String tail = content.substring(start, content.length);
    if (tipModel.template!.toLowerCase().startsWith(_tipText.toLowerCase()) ||
        tipModel.keyword!.toLowerCase().startsWith(_tipText.toLowerCase())) {
      String newHeader = header.replaceRange(start - _tipText.length, start, tipModel.template!);
      widget.controller.text = "$newHeader$tail";
      //如果有指定从哪个位置开始，就指定位置
      if (tipModel.start != null) {
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(affinity: TextAffinity.upstream, offset: (header.length - _tipText.length) + tipModel.start!),
        );
      } else {
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(affinity: TextAffinity.upstream, offset: newHeader.length),
        );
      }
      Future.delayed(const Duration(milliseconds: 10), () {
        TextSelection selection = widget.controller.selection;
        int start = selection.start;
        int end = selection.end;
        if (start == end) {
          String content = widget.controller.text;
          String header = content.substring(0, start);
          if (header.endsWith("\n")) {
            header = header.substring(0, header.length - 1);
          }
          String tail = content.substring(start, content.length);
          widget.controller.text = "$header$tail";
          widget.controller.selection = EditUtils.createTextSelection(header);
        }
      });
    }
  }
}
