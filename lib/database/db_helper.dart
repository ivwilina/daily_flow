import 'package:dailyflow_prototype_2/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db!=null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}tasks.db';
      _db =  await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE IF NOT EXISTS $_tableName ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title STRING, note TEXT, date STRING, "
              "startTime STRING, endTime STRING, "
              "remind INTEGER, "
              "color INTEGER, "
              "isCompleted INTEGER)"
          );
        }
      );
    }
    catch(e) {
      print(e.toString());
      print("Cannot create database");
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson())??1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName,where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1,id]);
  }

}