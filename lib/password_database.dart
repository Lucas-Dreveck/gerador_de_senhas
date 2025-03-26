import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PasswordDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'passwords.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE passwords(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            value TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertPassword(String value) async {
    final db = await database;
    await db.insert('passwords', {'value': value});
  }
  
  static Future<List<String>> getPasswords() async {
    final db = await database;
    final maps = await db.query('passwords', orderBy: 'id DESC');
    final list = maps.map((e) => e['value'] as String).toList();
    return list;
  }
}