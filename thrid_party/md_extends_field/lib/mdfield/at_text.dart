import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AtText extends SpecialText {
  AtText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, {this.showAtBackground = false, this.start})
      : super(flag, ' ', textStyle, onTap: onTap);
  static const String flag = '@';
  final int? start;

  final bool showAtBackground;

  @override
  InlineSpan finishText() {
    final TextStyle? textStyle = this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atText,
            actualText: atText,
            start: start!,
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()..onTap = () => onTap?.call(atText)))
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start!,
            style: textStyle,
            recognizer: (TapGestureRecognizer()..onTap = () => onTap?.call(atText)));
  }
}

List<String> atList = <String>[
  '@Nevermore ',
  '@Dota2 ',
  '@Biglao ',
  '@艾莉亚·史塔克 ',
  '@丹妮莉丝 ',
  '@HandPulledNoodles ',
  '@Zmtzawqlp ',
  '@FaDeKongJian ',
  '@CaiJingLongDaLao ',
];
