import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> options = [
    'int',
    'double',
    'String',
    'num',
    'void',
    'extends',
    'class',
    'Widget',
    'StatefulWidget',
    'StatelessWidget',
    'abstract',
    'BuildContext',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawAutocomplete<String>(
        onSelected: (s) {
          print('$s');
        },
        optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<String> onSelected,
          Iterable<String> options,
        ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 0.0,
              child: Container(
                color: Theme.of(context).cardColor,
                constraints: BoxConstraints(maxHeight: 360),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    String text = options.elementAt(index);
                    return ListTile(
                      onTap: () {
                        onSelected.call(text);
                      },
                      title: Text(text),
                    );
                  },
                  itemCount: options.length,
                ),
              ),
            ),
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) return [];
          String text = textEditingValue.text;
          if (text.contains(' ')) {
            text = text.split(' ').last;
          }
          return options.where((element) => RegExp('(.*)$text(.*)', caseSensitive: false).hasMatch(element)).toList();
        },
        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
          );
        },
      ),
    );
  }
}
