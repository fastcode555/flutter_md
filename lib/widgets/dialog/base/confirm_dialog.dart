import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:xdlibrary/xdlibrary.dart';

/// @date 29/8/22
/// describe:
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String leftTitle;
  final String rightTitle;
  final VoidCallback? leftCallBack;
  final VoidCallback? rightCallBack;
  final Widget? child;

  const ConfirmDialog({
    this.title = '',
    this.content = '',
    this.leftTitle = '',
    this.rightTitle = '',
    this.leftCallBack,
    this.rightCallBack,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            child ??
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(content),
                ),
            const SizedBox(height: 6),
            const Divider(thickness: 1.0, height: 1.0),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: PinButton(
                      height: 40,
                      width: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                      ),
                      title: leftTitle,
                      onPressed: leftCallBack,
                    ),
                  ),
                  const VerticalDivider(thickness: 1.0, width: 1.0),
                  Expanded(
                    child: PinButton(
                      height: 40,
                      width: 150,
                      title: rightTitle,
                      style: TextStyle(color: context.primaryColor),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                      ),
                      onPressed: rightCallBack,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
