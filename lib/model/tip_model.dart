import 'dart:convert';

import 'package:json2dart_dbffi/json2dart_dbffi.dart';
import 'package:json2dart_safe/json2dart.dart';

class TipModel with BaseDbModel {
  String? template;
  String? keyword;
  String? desc;
  int? id;
  String? eg;
  List<TipModel> defaults = [
    TipModel.df("######", 'h6', "H6"),
    TipModel.df("#####", 'h5', "H5"),
    TipModel.df("####", 'h4', "H4"),
    TipModel.df("###", 'h3', "H3"),
    TipModel.df("##", 'h2', "H2"),
    TipModel.df("#", 'h1', "H1"),
    TipModel.df("****", 'b', "bold"),
    TipModel.df("---", '-', ''),
  ];

  TipModel({
    this.template,
    this.keyword,
    this.desc,
    this.id,
    this.eg,
  });

  TipModel.df(
    this.template,
    this.keyword,
    this.desc,
  );

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
