import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: Column(
          children: [
            const Text("1.这是测试"),
            const Text.rich(TextSpan(text: "2.这是测试")),
            RichText(text: const TextSpan(text: "3.这是测试", style: TextStyle(color: Colors.red))),
            const SelectableText("4.这是测试"),
            const SelectableText.rich(TextSpan(text: "5.这是测试")),
          ],
        ),
      ),
    );
  }
}
