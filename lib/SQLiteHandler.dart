import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'Note.dart';

class NotesDBHandler {
  final dbName = "notes.db";
  final tableName = "notes";

  final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "BLOB",
    "content": "BLOB",
    "dateCreated": "INTEGER",
    "dateEdited": "INTEDER",
    "noteColor": "INTEGER",
    "isArchived": "INTEGER"
  };

  static Database _db;

  Future<Database> get database async {
    _db = _db != null ? _db : await initDB();
    return _db;
  }

  initDB() async {
    var path = getDatabasesPath();
    var dbPath = join(await path, 'notes.db');

    Database dbConnection = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int ver) async {
//      print("executing create query");
      await db.execute(_buildCreateQuery());
    });

    await dbConnection.execute(_buildCreateQuery());
    _buildCreateQuery();
    return dbConnection;
  }

  String _buildCreateQuery() {
    String tmp = "";
    fieldMap.forEach((column, field) {
      tmp += "$column $field,";
    });
    tmp = tmp.substring(0, tmp.length - 1);
    String query = "CREATE TABLE IF NOT EXISTS $tableName($tmp)";
    return query;
  }

  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }

  Future<int> insertNote(Note note, bool isNew) async {
    final Database db = await database;

    await db.insert('notes', note.toMap(!isNew),
        conflictAlgorithm: ConflictAlgorithm.replace);

    if (isNew) {
      var one = await db.query('notes',
          orderBy: "dateEdited desc",
          where: "isArchived = ?",
          whereArgs: [0],
          limit: 1);
      int latestId = one.first["id"] as int;
      return latestId;
    }
    return note.id;
  }

  Future<bool> copyNote(Note note) async {
    final Database db = await database;
    try {
      await db.insert('notes', note.toMap(false),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (Error) {
      print("Error copying $Error");
      return false;
    }
    return true;
  }

  Future<bool> archiveNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      int idToUpdate = note.id;
      try {
        db.update('notes', note.toMap(true),
            where: "id = ?", whereArgs: [idToUpdate]);
        return true;
      } catch (Error) {
        print("Error archiving ${Error.toString()}");
        return false;
      }
    }
  }

  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.delete('notes', where: "id = ?", whereArgs: [note.id]);
        return true;
      } catch (Error) {
        print("Error deleting ${note.id}: ${Error.toString()}");
        return false;
      }
    }
  }

  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    final Database db = await database;
    var data = await db.query("notes",
        orderBy: "dateEdited desc", where: "isArchived = ?", whereArgs: [0]);
    return data;
  }
}
