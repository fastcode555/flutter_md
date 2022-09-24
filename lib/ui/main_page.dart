import 'dart:io';

import 'package:common/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/res/strings.dart';

import '../res/r.dart';
import '../widgets/hover_widget.dart';
import 'md_editor_page.dart';

const _lastOpenFileKey = "Last_Open_File_Key";

/// @date 23/9/22
/// describe:
class MainPage extends StatefulWidget {
  static const String routeName = "/ui/main_page";

  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  TabController? _controller;
  final List<String> _items = [];
  final Map<String, File> _fileMaps = {};
  final List<String> _recordLastOpenFiles = [];
  int count = 1;

  @override
  void initState() {
    super.initState();
    count = Gs.read<int>(runtimeType.toString()) ?? 1;
    //读取上次打开的文件
    List<String> files = Gs.readList<String>(_lastOpenFileKey) ?? _recordLastOpenFiles;
    if (files.isNotEmpty) {
      for (String path in files) {
        try {
          File file = File(path);
          if (file.existsSync()) {
            String content = file.readAsStringSync();
            print(content);
            _items.add(file.path);
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initController();

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: Ids.newFile.tr,
                onPressed: () {
                  count++;
                  Gs.write(runtimeType.toString(), count);
                  _items.add('NewFile$count.md');
                  setState(() {});
                },
                icon: Image.asset(R.icNewFile, color: Colors.red),
              ),
              IconButton(
                tooltip: Ids.openFile.tr,
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    dialogTitle: Ids.pleaseSelectTheRequiredMarkdownFile.tr,
                    type: FileType.custom,
                    allowedExtensions: ["md"],
                  );
                  if (result != null && result.files.isNotEmpty) {
                    String? path = result.files[0].path;
                    if (path != null && !_items.contains(path)) {
                      _items.add(path);
                      setState(() {});
                    }
                  }
                },
                icon: const Icon(Icons.file_open_rounded),
              ),
              if (_items.isNotEmpty)
                Expanded(
                  child: TabBar(
                    tabs: _items.mapWidget((index, t) => _buildTab(index, t, context)),
                    controller: _controller,
                    isScrollable: true,
                    unselectedLabelColor: context.primaryColor.withOpacity(0.5),
                    labelColor: context.primaryColor,
                  ),
                )
            ],
          ),
          const Divider(thickness: 1, height: 1),
          Expanded(
            child: _items.isEmpty
                ? Center(child: Text(Ids.welcomeToFlutterMarkdownEditor.tr))
                : TabBarView(
                    controller: _controller,
                    children: _items.mapWidget(_buildTabPage),
                  ),
          ),
        ],
      ),
    );
  }

  ///创建Tab页面
  Widget _buildTab(int index, String item, BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(_getName(item)),
          GestureDetector(
            onTap: () {
              _items.removeAt(index);
              setState(() {});
              _fileMaps.remove(item);
            },
            child: HoverWidget(
              hoverDecoration: BoxDecoration(shape: BoxShape.circle, color: context.primaryColor),
              builder: (bool isHovered) {
                return Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: isHovered ? Colors.white : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///获取标题名
  String _getName(String item) {
    File? file = File(item);
    if (file.existsSync()) {
      return file.name;
    }
    file = _fileMaps[item];
    if (file != null) {
      return file.name;
    }
    return "$item*";
  }

  ///创建页面
  Widget _buildTabPage(int index, String item) {
    File file = File(item);
    if (!file.existsSync()) {
      File? newFile = _fileMaps[item];
      return MdEditorPage(
        file: newFile,
        key: ValueKey(item),
        tag: item,
        callBack: (tag, file) {
          _fileMaps[tag!] = file!;
          setState(() {});
        },
      );
    } else {
      return MdEditorPage(file: file, tag: item, key: ValueKey(item));
    }
  }

  ///初始化Controller
  void _initController() {
    if ((_controller == null || _controller?.length != _items.length) && _items.isNotEmpty) {
      _saveLastOpen();
      _controller = TabController(length: _items.length, vsync: this, initialIndex: _items.length - 1);
    }
  }

  ///保存上次打开的文件
  void _saveLastOpen() {
    _recordLastOpenFiles.clear();
    for (String path in _items) {
      File? file = File(path);
      if (file.existsSync()) {
        _recordLastOpenFiles.add(file.path);
        continue;
      }
      file = _fileMaps[path];
      if (file != null && file.existsSync()) {
        _recordLastOpenFiles.add(file.path);
        continue;
      }
    }
    Gs.write(_lastOpenFileKey, _recordLastOpenFiles);
  }
}
