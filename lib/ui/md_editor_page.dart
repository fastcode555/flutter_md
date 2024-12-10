import 'dart:io';

import 'package:common/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/res/strings.dart';

import '../model/edit_action_model.dart';
import '../widgets/editor_action_bar.dart';
import '../widgets/editor_panel.dart';
import 'markdown_page.dart';

typedef CreateFileCallback = Function(String? tag, File? file);

class MdEditorPage extends StatefulWidget {
  final File? file;
  final String? tag;
  final CreateFileCallback? callBack;
  static const String routeName = '/widgets/md_editor_page';

  const MdEditorPage({this.file, this.tag, this.callBack, super.key});

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

  File? _file;

  @override
  void initState() {
    super.initState();
    _file = widget.file;
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
                      file: _file,
                      controller: _controller,
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
                    return MarkdownPage(file: _file, data: _controller.text);
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
              Expanded(child: Text(_file?.name ?? '')),
              ValueListenableBuilder<String>(
                valueListenable: _notifier,
                builder: (_, data, __) {
                  return Text(data == '0.00' ? '' : '$data% ', textAlign: TextAlign.end);
                },
              ),
              const SizedBox(width: 6),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (_, data, __) {
                  var selectedText = '';
                  var selection = _controller.selection;
                  var start = selection.start;
                  var end = selection.end;
                  if (start != end) {
                    selectedText = _controller.text.substring(start, end).replaceAll('\n', '').replaceAll(' ', '');
                  }
                  var totalLength = _controller.text.replaceAll('\n', '').replaceAll(' ', '').length;
                  return Row(
                    children: [
                      if (start != end) Text('select: ${selectedText.length}  '),
                      if (start != end) Text('unselect: ${totalLength - selectedText.length}  '),
                      Text('total: $totalLength'),
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
    var model = _actionNotifier.value;
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
    } else if (model.action == EditActionModel.save) {
      _saveFile();
    } else if (model.action == EditActionModel.saveAs) {
      _saveAsFile();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _actionNotifier.removeListener(_listenerPanelChanged);
  }

  ///保存文件
  void _saveFile() async {
    if (_file == null) {
      var outputFile = await FilePicker.platform.saveFile(
        dialogTitle: Ids.pleaseSelectAnOutputFile.tr,
        fileName: widget.tag ?? 'NewFile.md',
      );
      if (outputFile != null) {
        _file = File(outputFile);
        widget.callBack?.call(widget.tag, _file);
      }
      setState(() {});
    }
    _file?.writeAsString(_controller.text);
  }

  ///另存文件为
  void _saveAsFile() async {
    var outputFile = await FilePicker.platform.saveFile(
      dialogTitle: Ids.pleaseSelectAnOutputFile.tr,
      fileName: widget.tag ?? 'NewFile.md',
    );
    if (outputFile != null) {
      var file = File(outputFile);
      file.writeAsString(_controller.text);
      _file ??= file;
    }
  }
}
