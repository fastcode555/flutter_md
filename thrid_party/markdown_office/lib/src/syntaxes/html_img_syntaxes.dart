import 'package:charcode/charcode.dart';
import 'package:markdown/markdown.dart' as md;

/// @date 16/8/22
/// describe:
class HtmlImgSyntax extends md.TextSyntax {
  static final _regAttr = RegExp(r'<img .*?=.*?>');
  static final _regAttrs = RegExp(r' .*?=.*?(?=[>| ])');
  static final _contentExp = RegExp(r'(?<=").*?(?=")');

  HtmlImgSyntax() : super(r'<img .*?>.*?[</img>]*', startCharacter: $lt, sub: 'html_img');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if ((match.start > 0 && match.input.substring(match.start - 1, match.start) == '/')) {
      // Just use the original matched text.
      parser.advanceBy(match.group(0)!.length);
      return false;
    }
    String regexContent = match.group(0)!;
    md.Element element = md.Element.text(substitute, regexContent);
    if (_regAttr.hasMatch(regexContent)) {
      String fontContent = _regAttr.firstMatch(regexContent)!.group(0)!;
      if (_regAttrs.hasMatch(fontContent)) {
        List<RegExpMatch> matches = _regAttrs.allMatches(fontContent).toList();
        for (RegExpMatch exp in matches) {
          List<String>? results = exp.group(0)?.split("=");
          if (results != null && results.isNotEmpty) {
            String value = results[1].trim();
            //取出双引号内的内容
            if (_contentExp.hasMatch(value)) {
              value = _contentExp.firstMatch(value)?.group(0) ?? value;
            }
            element.attributes[results[0].trim()] = value.trim();
          }
        }
      }
      parser.addNode(element);
      return true;
    }
    return false;
  }
}
