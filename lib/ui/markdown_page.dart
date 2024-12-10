import 'dart:io';

import 'package:flutter/material.dart';
import 'package:markdown_office/markdown_office.dart';

class MarkdownPage extends StatefulWidget {
  final File? file;
  final String? data;

  const MarkdownPage({this.file, this.data, super.key});

  @override
  _MarkdownPageState createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MarkdownOffice(file: widget.file, data: widget.data);
  }

  @override
  bool get wantKeepAlive => true;
}
