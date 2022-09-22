import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:xdlibrary/xdlibrary.dart';

import '../../res/strings.dart';
import 'base/dialog_header.dart';

/// @date 19/9/22
/// describe:插入链接的弹窗
class InsertLinkDialog extends StatefulWidget {
  final Function(String desc, String content) callback;

  InsertLinkDialog({required this.callback, super.key});

  @override
  _InsertLinkDialogState createState() => _InsertLinkDialogState();
}

class _InsertLinkDialogState extends State<InsertLinkDialog> {
  ///链接描述的controller
  final TextEditingController _descController = TextEditingController();

  ///链接的controller
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DialogHeader(
      lable: Ids.insertLink.tr,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InputField(
            controller: _descController,
            hintText: Ids.pleaseEnterLinkDescription.tr,
          ),
          const SizedBox(height: 8),
          _InputField(
            controller: _linkController,
            onEditingComplete: _confirm,
            hintText: Ids.pleaseEnterTheLink.tr,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _confirm,
            child: Text(Ids.confirm.tr),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _confirm() {
    widget.callback.call(_descController.text, _linkController.text);
    Get.dismiss();
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onEditingComplete;

  const _InputField({this.controller, this.hintText = '', this.onEditingComplete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputField(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      style: const TextStyle(),
      autoFocus: true,
      hintStyle: Theme.of(context).textTheme.bodyText1,
      decoration: BoxDecoration(
        border: Border.all(color: context.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      onEditingComplete: onEditingComplete,
      clearWidget: SizedBox(width: 40, height: 30, child: Icon(Icons.clear, color: context.primaryColor)),
      controller: controller,
      hintText: hintText,
    );
  }
}
