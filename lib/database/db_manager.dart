import 'dart:async';

import 'package:json2dart_dbffi/json2dart_dbffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'tip_model_dao.dart';

class DbManager extends BaseDbManager {
  static DbManager? _instance;

  factory DbManager() => _getInstance();

  static DbManager get instance => _getInstance();

  static DbManager _getInstance() => _instance ??= DbManager._internal();

  DbManager._internal();

  @override
  FutureOr<void> onCreate(Database db, int version) async {
    await db.execute(TipModelDao.tableSql());
  }

  TipModelDao? _tipModelDao;

  TipModelDao get tipModelDao => _tipModelDao ??= TipModelDao();
}
