import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/data/entity/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_database != null) return;
    try {
      final String path = await getDatabasesPath() + 'tasks.db';
      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          if (kDebugMode) {
            print('db is created!!');
          }
          return db.execute('CREATE TABLE IF NOT EXISTS $_tableName '
              '(id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, color INTEGER,'
              'date STRING, startTime STRING, endTime STRING,'
              'reminder INTEGER, repeat STRING, isCompleted INTEGER) ');
        },
      );
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
  }

  static Future<int> insertDb({required Task task}) async {
    if (kDebugMode) {
      print('insert function called.');
    }
    return await _database?.insert(_tableName, task.toJson()) ?? -1;
  }

  static Future<List<Map<String, dynamic>>> getAllTask() async {
    if (kDebugMode) {
      print('getAllTask called.');
    }
    return await _database!.query(_tableName);
  }

  static Future<int> deleteTask(Task task) async {
    return await _database!
        .delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<int> submitCompletedTask(int id) async {
    return await _database!.rawUpdate('''
       UPDATE $_tableName SET isCompleted=? WHERE id = ?
    ''', [1, id]);
  }
}
