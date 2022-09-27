import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const List<String> kOptions = <String>[
  'A',
  'An',
  'And',
  'Ant',
  'Ball',
  'Basket',
  'Bounce',
  'Bakery',
  'Zoo',
  'Zebra',
  'Joo',
  'June',
  'King',
  'Kite',
  'Kama',
];

void main() {
  runApp(const MaterialApp(home: RawAutocompleteBasicFormPage(title: "Raw AutoComplete 2.0")));
}

class RawAutocompleteBasicFormPage extends StatefulWidget {
  const RawAutocompleteBasicFormPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  AutocompleteFormExample createState() => AutocompleteFormExample();
}

class AutocompleteFormExample extends State<RawAutocompleteBasicFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  String? _dropdownValue;
  String? _autocompleteSelection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RawAutocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return kOptions.where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      setState(() {
                        _autocompleteSelection = selection;
                      });
                    },
                    fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                        FocusNode focusNode, VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'This is an RawAutocomplete 2.0',
                        ),
                        focusNode: focusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        validator: (String? value) {
                          if (!kOptions.contains(value)) {
                            return 'Nothing selected.';
                          }
                          return null;
                        },
                      );
                    },
                    optionsViewBuilder:
                        (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 300.0,
                            child: ListView(
                              children: options
                                  .map((String option) => GestureDetector(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: ListTile(
                                          title: Card(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              option,
                                              style: TextStyle(fontSize: 18, color: Colors.pink),
                                            ),
                                          )),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Successfully submitted'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('DropdownButtonFormField: "$_dropdownValue"'),
                                Text('TextFormField: "${_textEditingController.text}"'),
                                Text('RawAutocomplete: "$_autocompleteSelection"'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
