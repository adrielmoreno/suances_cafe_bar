import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../features/todos/presentation/providers/to_dos_provider.dart';

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
            'CREATE TABLE IF NOT EXISTS ${TypeToDo.errand.name} (id TEXT PRIMARY KEY, name TEXT, date TEXT, isCompleted INTEGER)',
          );
        },
      );
    } catch (e) {
      log('Open: ${e.toString()}');
    }
  }

  Future<String?> insert(String tableName, Map<String, dynamic> values) async {
    try {
      final result = await _db.insert(tableName, values);
      return result > 0 ? values['id'] : null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> update(String tableName, Map<String, dynamic> values) async {
    try {
      final result = await _db.update(tableName, values,
          where: 'id =  ?', whereArgs: [values['id']]);
      return result > 0 ? values['id'] : null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> delete(String tableName, String id) async {
    try {
      final result =
          await _db.delete(tableName, where: 'id =  ?', whereArgs: [id]);
      return result > 0 ? id : null;
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
