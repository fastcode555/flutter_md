import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/res/strings.dart';

import '../model/edit_action_model.dart';
import '../res/r.dart';
import 'canet_button.dart';
import 'colour_widget.dart';
import 'poup/poup_manager.dart';

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
                icon: Image.asset(R.icTextDelete, color: context.primaryColor),
              ),
              _FontColorButton(notifier: widget.notifier),
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
                icon: Image.asset(R.icChangeLine, color: context.primaryColor),
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

  const _PanelVisibleWidget({super.key, required this.notifier});

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
            icon: Image.asset(R.icMdSplit, color: context.primaryColor),
          ),
        if (_isEdit)
          IconButton(
            tooltip: Ids.justShow.tr,
            onPressed: () {
              widget.notifier.value = EditActionModel(action: EditActionModel.justShow);
              _isEdit = false;
              setState(() {});
            },
            icon: Image.asset(R.icMdEye, color: context.primaryColor),
          ),
      ],
    );
  }
}

///颜色按钮
class _FontColorButton extends StatelessWidget {
  final ValueNotifier<EditActionModel?>? notifier;

  const _FontColorButton({this.notifier, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isShow = false;
    return MouseRegion(
      onEnter: (_) {
        print("onExit");
        if (isShow) return;
        isShow = true;
        showPoup(
          context,
          child: ColourWidget(
            onTap: (color) {
              notifier?.value = EditActionModel(action: EditActionModel.font, content: color);
              Get.pop();
            },
          ),
          constraints: const BoxConstraints(maxWidth: 200),
        );
      },
      onHover: (_) {
        print("isHover");
      },
      onExit: (_) {
        print("onExit");
        if (isShow) {
          isShow = false;
        }
      },
      child: IconButton(
        onPressed: () => notifier?.value = EditActionModel(action: EditActionModel.font, content: "red"),
        icon: const Icon(Icons.format_color_text),
      ),
    );
  }
}
