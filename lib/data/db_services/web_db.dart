import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../presentation/views/todos/provider/to_dos_provider.dart';

class WebDB {
  static const String dbName = 'suances_db';
  late BoxCollection _db;
  late CollectionBox<Map<dynamic, dynamic>> _box;

  WebDB() {
    openDB();
  }

  Future<void> openDB() async {
    try {
      final dbPath =
          !kIsWeb ? (await getApplicationDocumentsDirectory()).path : null;
      _db = await BoxCollection.open(
        dbName,
        {TypeToDo.errand.name},
        path: '$dbPath/$dbName',
      );
    } catch (e) {
      log('Open: ${e.toString()}');
    }
  }

  Future<void> insert(String tableName, Map<String, dynamic> values) async {
    try {
      _box = await _db.openBox<Map>(tableName);
      await _box.put(values['id'], values);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update(String tableName, Map<String, dynamic> values) async {
    try {
      _box = await _db.openBox<Map>(tableName);
      await _box.put(values['id'], values);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> delete(String tableName, String id) async {
    try {
      _box = await _db.openBox<Map>(tableName);
      await _box.delete(id);
    } catch (e) {
      log('Delete: $e');
    }
  }

  Future<List<Map<dynamic, dynamic>?>> queryAll(String tableName) async {
    try {
      _box = await _db.openBox<Map>(tableName);
      final keys = await _box.getAllKeys();
      final objets = await _box.getAll(keys);
      return objets;
    } catch (e) {
      log('Query : $e');
      return [];
    }
  }

  Future<void> close() async {
    try {
      _db.close();
    } catch (e) {
      log('Close: $e');
    }
  }
}
