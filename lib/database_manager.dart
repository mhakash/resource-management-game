import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String resourceConfig = '''
{
  "resources":{
    "iron-ore":{"name":"iron-ore", "quantity":0},
    "iron-ingot":{"name":"iron-ingot", "quantity":5}
  }
}
''';

class DatabaseManager {
  DatabaseManager._();
  static final DatabaseManager instance = DatabaseManager._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database as Database;
    _database = await _initDatabase();
    return _database as Database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'game.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE resources (
            id TEXT PRIMARY KEY,
            data TEXT
          )
        ''');
        await db.execute('''
          INSERT INTO resources (id, data)
          VALUES ('resources', '$resourceConfig')
        ''');
      },
    );
  }

  Future<String> getResources() async {
    final Database db = await database;
    var x =
        await db.query('resources', where: 'id = ?', whereArgs: ['resources']);

    return x[0]['data'] as String;
  }

  Future<void> setResources(String data) async {
    final Database db = await database;
    await db.update('resources', {'data': data},
        where: 'id = ?', whereArgs: ['resources']);
  }
}
