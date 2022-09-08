import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get cursor (caret) position',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Get cursor (caret) position'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _textFieldKey = GlobalKey();
  TextStyle _textFieldStyle = TextStyle(fontSize: 20);
  TextEditingController _textFieldController = TextEditingController();
  late TextField _textField;
  double xCaret = 0.0;
  double yCaret = 0.0;
  double painterWidth = 0.0;
  double painterHeight = 0.0;
  double preferredLineHeight = 0.0;

  @override
  void initState() {
    super.initState();

    /// Listen changes on your text field controller
    _textFieldController.addListener(() {
      _updateCaretOffset(_textFieldController.text);
    });
  }

  void _updateCaretOffset(String text) {
    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: _textFieldStyle,
        text: text,
      ),
    );
    painter.layout();

    TextPosition cursorTextPosition = _textFieldController.selection.base;
    Rect caretPrototype = Rect.fromLTWH(0.0, 0.0, _textField.cursorWidth, _textField.cursorHeight ?? 0);
    Offset caretOffset = painter.getOffsetForCaret(cursorTextPosition, caretPrototype);
    setState(() {
      xCaret = caretOffset.dx;
      yCaret = caretOffset.dy;
      painterWidth = painter.width;
      painterHeight = painter.height;
      preferredLineHeight = painter.preferredLineHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    String text = '''
        xCaret: $xCaret
        yCaret: $yCaret
        yCaretBottom: ${yCaret + preferredLineHeight}
        ''';

    _textField = TextField(
      controller: _textFieldController,
      keyboardType: TextInputType.multiline,
      key: _textFieldKey,
      style: _textFieldStyle,
      minLines: 1,
      maxLines: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text),
          Padding(
            padding: const EdgeInsets.all(40),
            child: _textField,
          ),
        ],
      ),
    );
  }
}
