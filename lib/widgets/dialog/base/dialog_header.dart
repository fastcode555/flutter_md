import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// @date 26/8/22
/// describe:

class DialogHeader extends StatelessWidget {
  final String? lable;
  final Widget body;
  final bool showClose;
  final double width;

  const DialogHeader({
    required this.body,
    super.key,
    this.lable,
    this.showClose = true,
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (lable != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                Center(
                  child: Text(lable ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                if (showClose)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: const Icon(Icons.close), onPressed: Get.pop),
                  )
              ],
            ),
          ),
          body,
        ],
      );
    }
    return Stack(
      children: [
        body,
        Align(
          alignment: Alignment.topRight,
          child: IconButton(icon: const Icon(Icons.close), onPressed: Get.pop),
        ),
      ],
    );
  }
}
