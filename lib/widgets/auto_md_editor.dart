import 'dart:async';

import 'package:flutter/material.dart';

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

class AutoMdEditor extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxShowCount;
  final double itemHeight;
  final double hintWidth;
  final double padding;

  const AutoMdEditor({
    required this.controller,
    required this.focusNode,
    this.maxShowCount = 8,
    this.itemHeight = 40.0,
    this.hintWidth = 300,
    this.padding = 16.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      onSelected: (s) {
        print('$s');
      },
      textEditingController: controller,
      focusNode: focusNode,
      optionsViewBuilder: _optionsViewBuilder,
      optionsBuilder: _optionsBuilder,
      fieldViewBuilder: _fieldViewBuilder,
    );
  }

  ///构建提示的文本
  Widget _optionsViewBuilder(_, onSelected, options) {
    return Stack(
      children: [
        Positioned(
          left: padding,
          child: SizedBox(
            width: hintWidth - padding * 2,
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.red,
                height: (options.length > maxShowCount ? maxShowCount : options.length) * itemHeight,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    String text = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected.call(controller.text + text),
                      child: Container(
                        height: itemHeight,
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
    text = text.split("\n").last;
    if (text.contains(' ')) {
      text = text.split(' ').last;
    }
    return _options.where((e) => _filterValue(e, text)).toList();
  }

  ///创建的文本编辑框
  Widget _fieldViewBuilder(_, textEditingController, focusNode, onFieldSubmitted) {
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      maxLines: null,
      onSubmitted: (String value) => onFieldSubmitted(),
      decoration: const InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
      ),
    );
  }

  bool _filterValue(String element, String text) {
    return element != text && element.toLowerCase().startsWith(text.toLowerCase());
  }
}
