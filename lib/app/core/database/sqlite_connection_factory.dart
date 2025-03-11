import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

class SqliteConnectionFactory {
  static const String _DATABASE_NAME = 'todo_list_provider.db';
  static const int _DATABASE_VERSION = 1;

  static final SqliteConnectionFactory? _instance;

  Database? _database;
  final _lock = Lock();

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    if (_instance == null) {
      return SqliteConnectionFactory._();
    }
    return _instance!;
  }

  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    var databasePathFinal = join(databasePath, _DATABASE_NAME);
    if (_database == null) {
      await _lock.synchronized(() async {
        _database = await openDatabase(
          databasePathFinal,
          version: _DATABASE_VERSION,
          onConfigure: _onConfigure,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade,
        );
      });
    }
    return _database!;
  }

  void closeConnection() {
    if (_database != null) {
      _database!.close();
      _database = null;
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        done INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS todo');
    await _onCreate(db, newVersion);
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    await _onUpgrade(db, oldVersion, newVersion);
  }
}
