import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../model/edit_action_model.dart';
import '../model/tip_model.dart';
import '../utils/edit_utils.dart';
import 'auto_complete_editor.dart';
import 'dialog/insert_image_dialog.dart';
import 'dialog/insert_link_dialog.dart';
import 'mutiline_editor.dart';

/// @date 16/9/22
/// describe:
class EditorPanel extends StatefulWidget {
  final File? file;
  final TextEditingController? controller;
  final bool autofocus;
  final ValueNotifier<String>? notifier;
  final ValueNotifier<EditActionModel?>? actionNotifier;
  final bool autoEmpty;
  final FocusNode? focusNode;

  const EditorPanel({
    required this.file,
    super.key,
    this.autofocus = false,
    this.autoEmpty = false,
    this.controller,
    this.notifier,
    this.actionNotifier,
    this.focusNode,
  });

  @override
  _EditorPanelState createState() => _EditorPanelState();
}

class _EditorPanelState extends State<EditorPanel> {
  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<EditActionModel?> _actionNotifier;

  ///提示高亮的位置
  final ValueNotifier<int> hightlightNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _actionNotifier = widget.actionNotifier ?? ValueNotifier(null);
    _actionNotifier.addListener(_barActionCallBack);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ScrollStatusListener(
        metricsChangedListener: _metricsChangedListener,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!(widget.focusNode?.hasFocus ?? false)) {
                  widget.focusNode?.requestFocus();
                }
              },
              child: Stack(
                children: [
                  AutoCompleteEditor(
                    controller: widget.controller!,
                    focusNode: widget.focusNode!,
                    hintWidth: constraints.maxWidth,
                    hintHeight: constraints.maxHeight,
                    highlightedOptionIndex: hightlightNotifier,
                    options: TipModel.defaultMds,
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return MultilineEditor(
                        file: widget.file,
                        scrollController: _scrollController,
                        controller: textEditingController,
                        autofocus: widget.autofocus,
                        focusNode: focusNode,
                        autoEmpty: widget.autoEmpty,
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ///监听滚动进度的变化
  void _metricsChangedListener(ScrollMetrics value) {
    var progress = ((value.pixels / value.maxScrollExtent) * 100.toDouble());
    progress = progress < 0 ? 0 : (progress > 100 ? 100 : progress);
    widget.notifier?.value = progress.toStringAsFixed(2);
  }

  ///响应操作栏的状态变化
  void _barActionCallBack() {
    if (_actionNotifier.value != null && widget.controller != null) {
      var model = _actionNotifier.value!;
      for (var action in [
        EditActionModel.splitScreen,
        EditActionModel.justShow,
        EditActionModel.save,
        EditActionModel.saveAs
      ]) {
        if (model.action == action) {
          return;
        }
      }

      var controller = widget.controller!;
      var start = controller.selection.start;
      var end = controller.selection.end;
      var content = controller.text;
      var selectTxt = content.substring(start, end);
      if (start == end) {
        var header = content.substring(0, start);
        var tail = content.substring(start, content.length);
        if (model.action == EditActionModel.insert) {
          var header = content.substring(0, start);
          var tail = content.substring(start, content.length);
          var newHeader = "$header${model.content}";
          controller.text = "$newHeader$tail";
          controller.selection = EditUtils.createTextSelection(newHeader);
        } else if (model.action == EditActionModel.insertLink) {
          _insertLink(header, tail);
        } else if (model.action == EditActionModel.insertImage) {
          _insertImage(header, tail);
        } else if (model.action == EditActionModel.insertDelimiter) {
          header = '$header\n-------------------------------------\n';
          controller.text = '$header$tail';
          controller.selection = EditUtils.createTextSelection(header);
        } else if (model.action == EditActionModel.newLine) {
          header = '$header<br/>';
          controller.text = '$header$tail';
          controller.selection = EditUtils.createTextSelection(header);
        } else if (model.action == EditActionModel.font) {
          var newHeader = '$header<font color=${model.content}>';
          var newTail = '</font>$tail';
          controller.text = "$newHeader$newTail";
          controller.selection = EditUtils.createTextSelection(newHeader);
        } else if (model.action == EditActionModel.underline) {
          var newHeader = '$header<u>';
          var newTail = '</u>$tail';
          controller.text = "$newHeader$newTail";
          controller.selection = EditUtils.createTextSelection(newHeader);
        } else if (model.action == EditActionModel.bold) {
          _createMarkTextStyle('**', header, tail, controller);
        } else if (model.action == EditActionModel.italic) {
          _createMarkTextStyle('*', header, tail, controller);
        } else if (model.action == EditActionModel.lineThrough) {
          _createMarkTextStyle('~~', header, tail, controller);
        }
      } else if (model.action == EditActionModel.bold) {
        controller.text = content.replaceRange(start, end, '**${content.substring(start, end)}**');
      } else if (model.action == EditActionModel.italic) {
        controller.text = content.replaceRange(start, end, '*${content.substring(start, end)}*');
      } else if (model.action == EditActionModel.underline) {
        controller.text = content.replaceRange(start, end, '<u>${content.substring(start, end)}</u>');
      } else if (model.action == EditActionModel.font) {
        var fontContent = '<font color=${model.content}>${content.substring(start, end)}</font>';
        controller.text = content.replaceRange(start, end, fontContent);
      } else if (model.action == EditActionModel.lineThrough) {
        controller.text = content.replaceRange(start, end, '~~${content.substring(start, end)}~~');
      } else if (model.action == EditActionModel.insertLink) {
        controller.text = content.replaceRange(start, end, '[]($selectTxt)');
        controller.selection = EditUtils.lengthSelection(start + 1);
      } else if (model.action == EditActionModel.insertImage) {
        var mdString = '![Alt]($selectTxt)';
        controller.text = content.replaceRange(start, end, mdString);
        controller.selection = EditUtils.lengthSelection(start + mdString.length);
      }
    }
    if (!(widget.focusNode?.hasFocus ?? true)) {
      widget.focusNode?.requestFocus();
    }
  }

  ///创建markdown文本的文件的风格
  void _createMarkTextStyle(String symbol, String header, String tail, TextEditingController controller) {
    var newHeader = "$header$symbol";
    var newTail = "$symbol$tail";
    controller.text = "$newHeader$newTail";
    controller.selection = EditUtils.createTextSelection(newHeader);
  }

  @override
  void dispose() {
    super.dispose();
    _actionNotifier.removeListener(_barActionCallBack);
  }

  ///插入链接的操作
  void _insertLink(String header, String tail) {
    Get.dialog(
      Stack(
        children: [
          Center(
            child: InsertLinkDialog(
              callback: (String desc, String content) {
                var newHeader = desc.isNotEmpty ? '$header[$desc]($content)' : '$header[';
                var newTail = desc.isEmpty ? ']($content)$tail' : tail;
                widget.controller?.text = "$newHeader$newTail";
                widget.controller?.selection = EditUtils.createTextSelection(newHeader);
              },
            ),
          ),
        ],
      ),
    );
  }

  ///插入图片链接的操作
  void _insertImage(String header, String tail) {
    Get.dialog(
      Stack(
        children: [
          Center(
            child: InsertImageDialog(
              callback: (String desc, String content) {
                var newHeader = "$header$desc($content)";
                widget.controller?.text = "$newHeader$tail";
                widget.controller?.selection = EditUtils.createTextSelection(newHeader);
              },
            ),
          ),
        ],
      ),
    );
  }
}
