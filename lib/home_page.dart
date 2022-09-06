import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/md_editor_panel.dart';
import 'package:markdown_office/markdown_office.dart';

/// @date 6/9/22
/// describe:
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> _notifier = ValueNotifier(true);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResizableFulWidget(
      visibleNotifier: _notifier,
      builder: (_) {
        return [
          MdEditorPanel(controller: _controller),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (_, value, __) {
              return MarkdownOffice(data: _controller.text);
            },
          ),
        ];
      },
    );
  }
}
