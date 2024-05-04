import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../presentation/views/todos/provider/to_dos_provider.dart';

class LocalDB {
  static const String dbName = 'suances_db.sqlite';
  static const int version = 1;
  late Database _db;

  LocalDB() {
    openDB(dbName, version);
  }

  Future<void> openDB(String dbName, int version) async {
    try {
      final path = (await getApplicationDocumentsDirectory()).path;
      _db = await openDatabase(
        '$path/$dbName',
        version: version,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ${TypeToDo.errand.name} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT, isCompleted INTEGER)',
          );
        },
      );
    } catch (e) {
      log('Open: ${e.toString()}');
    }
  }

  Future<int?> insert(String tableName, Map<String, dynamic> values) async {
    try {
      return await _db.insert(tableName, values);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int?> update(
      String tableName, Map<String, dynamic> values, int id) async {
    try {
      return await _db
          .update(tableName, values, where: 'id =  ?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int?> delete(String tableName, int id) async {
    try {
      return await _db.delete(tableName, where: 'id =  ?', whereArgs: [id]);
    } catch (e) {
      log('Delete: e');
      return null;
    }
  }

  Future<List<Map>?> queryAll(String tableName) async {
    try {
      return await _db.query(tableName);
    } catch (e) {
      log('Query : $e');
      return null;
    }
  }

  Future<void> close() async {
    try {
      await _db.close();
    } catch (e) {
      log('Close: $e');
    }
  }
}
