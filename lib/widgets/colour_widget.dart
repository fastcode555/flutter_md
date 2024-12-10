import 'package:flutter/material.dart';
import 'package:markdown_office/markdown_office.dart';

/// @date 20/9/22
/// describe: MarkDown的色彩列表
class ColourWidget extends StatelessWidget {
  final ValueChanged<String> onTap;

  const ColourWidget({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var keys = Utils.colors.keys.toList();
    return SizedBox(
      width: 200,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: keys.length,
        itemBuilder: (_, index) {
          var key = keys[index];
          return GestureDetector(
            child: Container(color: Utils.colors[key]),
            onTap: () => onTap.call(key),
          );
        },
      ),
    );
  }
}
