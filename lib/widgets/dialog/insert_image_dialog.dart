/// @date 19/9/22
/// describe: 插入图片的弹窗
import 'package:common/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:xdlibrary/xdlibrary.dart';

import '../../res/strings.dart';
import 'base/dialog_header.dart';

/// @date 19/9/22
/// describe:插入链接的弹窗
class InsertImageDialog extends StatefulWidget {
  final Function(String desc, String content) callback;

  InsertImageDialog({required this.callback, super.key});

  @override
  _InsertImageDialogState createState() => _InsertImageDialogState();
}

class _InsertImageDialogState extends State<InsertImageDialog> {
  ///链接描述的controller

  ///链接的controller
  final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DialogHeader(
      lable: Ids.insertImage.tr,
      body: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Expanded(
                  child: _InputField(
                    controller: _linkController,
                    onEditingComplete: _confirm,
                    hintText: Ids.pleaseEnterTheLink.tr,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () async {
                    FilePickerResult? file = await FilePicker.platform
                        .pickFiles(dialogTitle: Ids.pleaseSelectImage.tr, type: FileType.image);
                    if (file != null && file.files.isNotEmpty) {
                      PlatformFile platformFile = file.files[0];
                      _linkController.text = platformFile.path ?? "";
                      _confirm();
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _confirm,
              child: Text(Ids.confirm.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm() {
    widget.callback.call('![Alt]', _linkController.text);
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
      height: 50,
      hintStyle: Theme.of(context).textTheme.bodyLarge,
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
