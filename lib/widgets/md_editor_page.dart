import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';

import '../model/edit_action_model.dart';
import 'editor_action_bar.dart';
import 'editor_panel.dart';
import 'markdown_page.dart';

class MdEditorPage extends StatefulWidget {
  static const String routeName = "/widgets/md_editor_page";
  final File? file;

  const MdEditorPage({this.file, super.key});

  @override
  _MdEditorPageState createState() => _MdEditorPageState();
}

class _MdEditorPageState extends State<MdEditorPage> {
  final TextEditingController _controller = TextEditingController();

  ///顶部的操作栏
  final ValueNotifier<EditActionModel?> _actionNotifier = ValueNotifier(null);

  ///阅读进度的变化
  final ValueNotifier<String> _notifier = ValueNotifier('0.00');
  final FocusNode _focusNode = FocusNode();

  ///是否是编辑模式
  bool _isEdit = true;

  @override
  void initState() {
    super.initState();
    _actionNotifier.addListener(_listenerPanelChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMainPage(),
    );
  }

  Widget _buildMainPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorActionBar(
          notifier: _actionNotifier,
        ),
        Expanded(
          child: Row(
            children: [
              if (_isEdit)
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: EditorPanel(
                      file: widget.file,
                      controller: _controller,
                      autofocus: false,
                      notifier: _notifier,
                      actionNotifier: _actionNotifier,
                      focusNode: _focusNode,
                    ),
                  ),
                ),
              if (_isEdit) const VerticalDivider(thickness: 1.0, width: 1.0),
              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (_, data, __) {
                    return MarkdownPage(file: widget.file, data: _controller.text);
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(child: Text(widget.file?.name ?? '')),
              ValueListenableBuilder<String>(
                valueListenable: _notifier,
                builder: (_, data, __) {
                  return Text('$data% ', textAlign: TextAlign.end);
                },
              ),
              const SizedBox(width: 6),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (_, data, __) {
                  String selectedText = "";
                  TextSelection selection = _controller.selection;
                  int start = selection.start;
                  int end = selection.end;
                  if (start != end) {
                    selectedText = _controller.text.substring(start, end).replaceAll("\n", "").replaceAll(" ", "");
                  }
                  int totalLength = _controller.text.replaceAll("\n", "").replaceAll(" ", "").length;
                  return Row(
                    children: [
                      if (start != end) Text("select: ${selectedText.length}  "),
                      if (start != end) Text("unselect: ${totalLength - selectedText.length}  "),
                      Text("total: $totalLength"),
                    ],
                  );
                },
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ],
    );
  }

  ///监听面板变化
  void _listenerPanelChanged() {
    EditActionModel? model = _actionNotifier.value;
    if (model == null) return;
    if (model.action == EditActionModel.splitScreen) {
      if (!_isEdit) {
        setState(() {
          _isEdit = true;
        });
      }
    } else if (model.action == EditActionModel.justShow) {
      if (_isEdit) {
        setState(() {
          _isEdit = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _actionNotifier.removeListener(_listenerPanelChanged);
  }
}
