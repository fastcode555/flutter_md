import 'package:flutter/material.dart';

/// @date 19/9/22
/// describe: 插入特殊符号的页面
class SpecialCaretWidget extends StatelessWidget {
  final ValueChanged<String> onTap;

  const SpecialCaretWidget({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildList("①②③④⑤⑥⑦⑧⑨⑩"),
            _buildList('❶❷❸❹❺❻❼❽❾❿'),
            _buildLists(
              ["Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ", "Ⅴ", "Ⅵ", "Ⅶ", "Ⅷ", 'Ⅸ', 'Ⅹ'],
            ),
            _buildLists(
              ["ⅰ", "ⅱ", "ⅲ", "ⅳ", "ⅴ", "ⅵ", "ⅶ", "ⅷ", 'ⅸ', 'ⅹ'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLists(List<String> strings) {
    List<Widget> buildItem() {
      List<Widget> items = [];
      for (int i = 0; i < strings.length; i++) {
        String item = strings[i];
        items.add(_buildChild(item));
      }
      return items;
    }

    return Row(children: buildItem());
  }

  Widget _buildList(String strings) {
    List<Widget> buildItem() {
      List<Widget> items = [];
      for (int i = 0; i < strings.length; i++) {
        String item = strings[i];
        items.add(_buildChild(item));
      }
      return items;
    }

    return Row(children: buildItem());
  }

  Widget _buildChild(String item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Text(item, style: const TextStyle(fontSize: 18)),
      ),
      onTap: () {
        onTap.call(item);
      },
    );
  }
}
