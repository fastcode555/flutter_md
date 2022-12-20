import 'package:common/common.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 16/8/22
/// describe:
class CommonSyntax extends md.TextSyntax {
  final RegExp regExp;

  CommonSyntax(
    String pattern,
    String contentPattern,
    String sub,
  )   : regExp = RegExp(contentPattern),
        super(pattern, sub: sub);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    String? data = match.group(0);
    if (data.isNotNullAndEmpty && regExp.hasMatch(data!)) {
      String? content = regExp.firstMatch(data)?.group(0);
      md.Element element = md.Element.text(substitute, content ?? '');
      element.generatedId = Encrypt.createUUID();
      parser.addNode(element);
      return true;
    }
    return false;
  }
}
