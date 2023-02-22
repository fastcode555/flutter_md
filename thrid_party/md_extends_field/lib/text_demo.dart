import 'dart:io';
import 'dart:math';

import 'package:md_extends_field/mdfield/dollar_text.dart';
import 'package:md_extends_field/mdfield/emoji_text.dart' as emoji;
import 'package:extended_list/extended_list.dart';
import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mdfield/at_text.dart';
import 'mdfield/my_extended_text_selection_controls.dart';
import 'mdfield/my_special_text_span_builder.dart';

class TextDemo extends StatefulWidget {
  const TextDemo({super.key});

  @override
  _TextDemoState createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {
  final TextEditingController _textEditingController = TextEditingController();
  final MyTextSelectionControls _myExtendedMaterialTextSelectionControls = MyTextSelectionControls();
  final GlobalKey<ExtendedTextFieldState> _key = GlobalKey<ExtendedTextFieldState>();
  final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder = MySpecialTextSpanBuilder();

  final FocusNode _focusNode = FocusNode();
  double _keyboardHeight = 0;
  double _preKeyboardHeight = 0;

  bool get showCustomKeyBoard => activeEmojiGird || activeAtGrid || activeDollarGrid;
  bool activeEmojiGird = false;
  bool activeAtGrid = false;
  bool activeDollarGrid = false;
  List<String> sessions = <String>[
    '[44] @Dota2 CN dota best dota',
    'yes, you are right [36].',
    '大家好，我是拉面，很萌很新 [12].',
    '\$Flutter\$. CN dev best dev',
    '\$Dota2 Ti9\$. Shanghai,I\'m coming.',
    'error 0 [45] warning 0',
    '<img src="https://images.pexels.com/photos/33109/fall-autumn-red-season.jpg?auto=compress&cs=tinysrgb&w=800"/>',
  ];

  @override
  Widget build(BuildContext context) {
    //FocusScope.of(context).autofocus(_focusNode);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final bool showingKeyboard = keyboardHeight > _preKeyboardHeight;
    _preKeyboardHeight = keyboardHeight;
    if ((keyboardHeight > 0 && keyboardHeight >= _keyboardHeight) || showingKeyboard) {
      activeEmojiGird = activeAtGrid = activeDollarGrid = false;
    }

    _keyboardHeight = max(_keyboardHeight, keyboardHeight);

    return SafeArea(
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('special text'),
          actions: <Widget>[
            TextButton(
              child: const Icon(
                Icons.backspace,
                color: Colors.white,
              ),
              onPressed: manualDelete,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: ExtendedListView.builder(
              extendedListDelegate: const ExtendedListDelegate(closeToTrailing: true),
              itemBuilder: (BuildContext context, int index) {
                final bool left = index % 2 == 0;
                final Image logo = Image.asset('assets/flutter_candies_logo.png', width: 30.0, height: 30.0);
                //print(sessions[index]);
                final Widget text = ExtendedText(
                  sessions[index],
                  textAlign: left ? TextAlign.left : TextAlign.right,
                  specialTextSpanBuilder: _mySpecialTextSpanBuilder,
                  onSpecialTextTap: (dynamic value) {
                    if (value.toString().startsWith('\$')) {
                      launch('https://github.com/fluttercandies');
                    } else if (value.toString().startsWith('@')) {
                      launch('mailto:zmtzawqlp@live.com');
                    }
                  },
                );
                List<Widget> list = <Widget>[logo, Expanded(child: text), Container(width: 30.0)];
                if (!left) {
                  list = list.reversed.toList();
                }
                return Row(
                  children: list,
                );
              },
              padding: const EdgeInsets.only(bottom: 10.0),
              reverse: true,
              itemCount: sessions.length,
            )),
            //  TextField()
            Container(height: 2.0, color: Colors.blue),
            ExtendedTextField(
              key: _key,
              minLines: 1,
              maxLines: 2,
              strutStyle: const StrutStyle(),
              specialTextSpanBuilder: MySpecialTextSpanBuilder(showAtBackground: true),
              controller: _textEditingController,
              selectionControls: _myExtendedMaterialTextSelectionControls,
              focusNode: _focusNode,
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        sessions.insert(0, _textEditingController.text);
                        _textEditingController.value = _textEditingController.value.copyWith(
                            text: '', selection: const TextSelection.collapsed(offset: 0), composing: TextRange.empty);
                      });
                    },
                    child: const Icon(Icons.send),
                  ),
                  contentPadding: const EdgeInsets.all(12.0)),
              //textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  void onToolbarButtonActiveChanged(double keyboardHeight, bool active, Function activeOne) {
    if (keyboardHeight > 0) {
      // make sure grid height = keyboardHeight
      _keyboardHeight = keyboardHeight;
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    }

    if (active) {
      activeDollarGrid = activeEmojiGird = activeAtGrid = false;
    }

    activeOne();
  }

  Widget buildCustomKeyBoard() {
    if (!showCustomKeyBoard) {
      return Container();
    }
    if (activeEmojiGird) {
      return buildEmojiGird();
    }
    if (activeAtGrid) {
      return buildAtGrid();
    }
    if (activeDollarGrid) {
      return buildDollarGrid();
    }
    return Container();
  }

  Widget buildEmojiGird() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Image.asset(emoji.EmojiUitl.instance.emojiMap['[${index + 1}]']!),
          behavior: HitTestBehavior.translucent,
          onTap: () {
            insertText('[${index + 1}]');
          },
        );
      },
      itemCount: emoji.EmojiUitl.instance.emojiMap.length,
      padding: const EdgeInsets.all(5.0),
    );
  }

  Widget buildAtGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context, int index) {
        final String text = atList[index];
        return GestureDetector(
          child: Align(
            child: Text(text),
          ),
          behavior: HitTestBehavior.translucent,
          onTap: () {
            insertText(text);
          },
        );
      },
      itemCount: atList.length,
      padding: const EdgeInsets.all(5.0),
    );
  }

  Widget buildDollarGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemBuilder: (BuildContext context, int index) {
        final String text = dollarList[index];
        return GestureDetector(
          child: Align(
            child: Text(text.replaceAll('\$', '')),
          ),
          behavior: HitTestBehavior.translucent,
          onTap: () {
            insertText(text);
          },
        );
      },
      itemCount: dollarList.length,
      padding: const EdgeInsets.all(5.0),
    );
  }

  void insertText(String text) {
    final TextEditingValue value = _textEditingController.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      _textEditingController.value = value.copyWith(
          text: newText,
          selection: value.selection.copyWith(baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      _textEditingController.value =
          TextEditingValue(text: text, selection: TextSelection.fromPosition(TextPosition(offset: text.length)));
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(_textEditingController.selection.base);
    });
  }

  void manualDelete() {
    //delete by code
    final TextEditingValue _value = _textEditingController.value;
    final TextSelection selection = _value.selection;
    if (!selection.isValid) {
      return;
    }

    TextEditingValue value;
    final String actualText = _value.text;
    if (selection.isCollapsed && selection.start == 0) {
      return;
    }
    final int start = selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;

    value = TextEditingValue(
      text: actualText.replaceRange(start, end, ''),
      selection: TextSelection.collapsed(offset: start),
    );

    final TextSpan oldTextSpan = _mySpecialTextSpanBuilder.build(_value.text);

    value = handleSpecialTextSpanDelete(value, _value, oldTextSpan, null);

    _textEditingController.value = value;
  }
}
