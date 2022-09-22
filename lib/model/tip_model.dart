import 'dart:convert';

import 'package:json2dart_safe/json2dart.dart';

class TipModel {
  String? template;
  String? keyword;
  String? desc;
  int? id;
  String? eg;

  ///选中文本之后开始的位置
  int? start;
  static List<TipModel> defaults = [
    TipModel.df("# ", 'h1', "H1"),
    TipModel.df("## ", 'h2', "H2"),
    TipModel.df("### ", 'h3', "H3"),
    TipModel.df("#### ", 'h4', "H4"),
    TipModel.df("##### ", 'h5', "H5"),
    TipModel.df("###### ", 'h6', "H6"),
    TipModel.df("****", '', "Bold", start: 2),
    TipModel.df("====", '', "Mark", start: 2),
    TipModel.df("~~~~", '', "Delete", start: 2),
    TipModel.df("---", '-', ''),
    TipModel.df("[]()", 'link', 'Insert Link', start: 1),
    TipModel.df("- [ ] ", '', 'CheckBox false', start: 6),
    TipModel.df("- [x] ", '', 'CheckBox true', start: 6),
    TipModel.df("![Alt]()", 'img', 'Insert Image', start: 7),
    TipModel.df("|\n-|-", '', "Table 2", start: 0),
    TipModel.df("||\n-|-|-", '', "Table 3", start: 0),
    TipModel.df("|||\n-|-|-|-", '', "Table 4", start: 0),
    TipModel.df("||||\n-|-|-|-|-", '', "Table 5", start: 0),
    TipModel.df("|||||\n-|-|-|-|-|-", '', "Table 6", start: 0),
    TipModel.df("||||||\n-|-|-|-|-|-|-", '', "Table 7", start: 0),
    TipModel.df("|||||||\n-|-|-|-|-|-|-|-", '', "Table 8", start: 0),
    TipModel.df("||||||||\n-|-|-|-|-|-|-|-|-", '', "Table 9", start: 0),
    TipModel.df("<u></u>", 'u', "Underline", start: 3),
    TipModel.df("<kbd></kbd>", 'kbd', "KBD", start: 5),
    TipModel.df("<font color=red></font>", 'font', "Font", start: 16),
    TipModel.df("<img src=\"\"/>", 'img', 'Insert Html Image', start: 10),
  ];

  TipModel({
    this.template,
    this.keyword,
    this.desc,
    this.id,
    this.eg,
    this.start,
  });

  TipModel.df(this.template, this.keyword, this.desc, {this.start});

  @override
  Map<String, dynamic> toJson() => {
        'template': template,
        'keyword': keyword,
        'desc': desc,
        'id': id,
        'eg': eg,
      };

  TipModel.fromJson(Map json) {
    template = json.asString('template');
    keyword = json.asString('keyword');
    desc = json.asString('desc');
    eg = json.asString('eg');
    id = json.asInt('id');
  }

  static TipModel toBean(Map json) => TipModel.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"id": id};

  @override
  int get hashCode => id?.hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is TipModel && id != null) {
      return other.id == id;
    }
    return super == other;
  }

  @override
  String toString() => jsonEncode(toJson());
}
