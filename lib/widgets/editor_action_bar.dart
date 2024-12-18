import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/res/strings.dart';
import 'package:flutter_tailwind/flutter_tailwind.dart';

import '../model/edit_action_model.dart';
import '../res/r.dart';
import 'canet_button.dart';
import 'font_color_button.dart';

/// @date 16/9/22
/// describe:标签器的功能栏
class EditorActionBar extends StatefulWidget {
  final bool isMarkdown;
  final ValueNotifier<EditActionModel?> notifier;

  const EditorActionBar({required this.notifier, this.isMarkdown = true, Key? key}) : super(key: key);

  @override
  _EditorActionBarState createState() => _EditorActionBarState();
}

class _EditorActionBarState extends State<EditorActionBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                tooltip: Ids.keep.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.save),
                icon: const Icon(Icons.save),
              ),
              IconButton(
                tooltip: Ids.saveAs.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.saveAs),
                icon: const Icon(Icons.save_as),
              ),
              const VerticalDivider(),
              IconButton(
                tooltip: Ids.boldStyle.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.bold),
                icon: const Icon(Icons.format_bold),
              ),
              IconButton(
                tooltip: Ids.italicStyle.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.italic),
                icon: const Icon(Icons.format_italic),
              ),
              IconButton(
                tooltip: Ids.underscore.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.underline),
                icon: const Icon(Icons.format_underline),
              ),
              IconButton(
                tooltip: Ids.strikeThrough.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.lineThrough),
                icon: R.icTextDelete.asset.grey700.s24.mk,
              ),
              FontColorButton(notifier: widget.notifier),
              IconButton(
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.background),
                icon: const Icon(Icons.format_color_fill),
              ),
              const VerticalDivider(),
              IconButton(
                tooltip: Ids.insertLink.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.insertLink),
                icon: const Icon(Icons.link_rounded),
              ),
              IconButton(
                tooltip: Ids.insertImage.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.insertImage),
                icon: const Icon(Icons.image),
              ),
              IconButton(
                tooltip: Ids.newline.tr,
                onPressed: () => widget.notifier.value = EditActionModel(action: EditActionModel.newLine),
                icon: R.icChangeLine.asset.s24.grey700.mk,
              ),
              CaretButton(
                onTap: (String value) {
                  widget.notifier.value = EditActionModel(content: value);
                  Get.pop();
                },
              ),
              const Spacer(),
              _PanelVisibleWidget(
                notifier: widget.notifier,
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1.0),
      ],
    );
  }
}

class _PanelVisibleWidget extends StatefulWidget {
  final ValueNotifier<EditActionModel?> notifier;

  const _PanelVisibleWidget({required this.notifier});

  @override
  __PanelVisibleWidgetState createState() => __PanelVisibleWidgetState();
}

class __PanelVisibleWidgetState extends State<_PanelVisibleWidget> {
  bool _isEdit = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isEdit)
          IconButton(
            tooltip: Ids.splitScreen.tr,
            onPressed: () {
              widget.notifier.value = EditActionModel(action: EditActionModel.splitScreen);
              _isEdit = true;
              setState(() {});
            },
            icon: R.icMdSplit.asset.grey700.s24.mk,
          ),
        if (_isEdit)
          IconButton(
            tooltip: Ids.justShow.tr,
            onPressed: () {
              widget.notifier.value = EditActionModel(action: EditActionModel.justShow);
              _isEdit = false;
              setState(() {});
            },
            icon: R.icMdEye.asset.s24.grey700.mk,
          ),
      ],
    );
  }
}
