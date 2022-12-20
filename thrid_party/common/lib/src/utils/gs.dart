import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

/// @date 22/7/22
/// describe:
/// GetStorage的建成，官网吹牛逼，比SharePreference好很多，实现是使用数据库实现的

class Gs {
  Gs._();

  ///从内存中读取字段，并转成object
  static T? readObj<T>(String key, [T Function(Map map)? builder, T? defaultValue]) {
    final box = GetStorage();
    Object? obj = box.read(key);
    if (obj == null) return defaultValue;
    if (obj is T) return obj as T;
    Map? map = obj as Map;
    return builder?.call(map);
  }

  ///从内存中读取List数组
  static List<T>? readList<T>(String key, {T Function(Map map)? builder, List<T>? defaultValue}) {
    final box = GetStorage();
    Object? obj = box.read(key);
    if (obj == null) return defaultValue;
    if (obj is List<T>) return obj;
    if (obj is List) {
      if (builder != null) {
        List<T> datas = [];
        List objs = obj;
        for (Object? single in objs) {
          if (single != null && single is Map) {
            datas.add(builder.call(single));
          } else {
            debugPrint("Can't parse it with Gs.");
          }
        }
      } else {
        return List<T>.from(obj);
      }
    }
  }

  static T? read<T>(String key, [T? defaultValue]) {
    final box = GetStorage();
    T? value = box.read<T>(key);
    if (value == null) return defaultValue;
    return value;
  }

  ///写入内存中
  static void write(String key, dynamic value) {
    final box = GetStorage();
    box.write(key, value);
  }

  static void remove(String key) {
    final box = GetStorage();
    box.remove(key);
  }

  static void clear() {
    final box = GetStorage();
    box.erase();
  }
}
