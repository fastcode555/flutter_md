import 'package:flutter_md/database/db_manager.dart';
import 'package:flutter_md/model/tip_model.dart';
import 'package:json2dart_dbffi/json2dart_dbffi.dart';

class TipModelDao extends BaseDao<TipModel> {
  static TipModelDao get of => DbManager.instance.tipModelDao;

  static const String _tableName = 'tip_model';

  TipModelDao() : super(_tableName, 'id');

  static String tableSql([String? tableName]) => '''
      CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` (
      `template` TEXT,
      `keyword` TEXT,
      `desc` TEXT,
      `eg` TEXT,
      `id` INTEGER PRIMARY KEY AUTOINCREMENT
      );''';

  @override
  TipModel fromJson(Map json) => TipModel.fromJson(json);
}
