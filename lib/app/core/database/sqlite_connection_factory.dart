import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todo_list_provider/app/core/database/sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static const String _DATABASE_NAME = 'todo_list_provider.db';
  static const int _DATABASE_VERSION = 1;

  // Correção: Inicializando a instância corretamente
  static final SqliteConnectionFactory _instance = SqliteConnectionFactory._();

  Database? _database;
  final _lock = Lock();

  // Construtor privado
  SqliteConnectionFactory._();

  // Factory que retorna sempre a mesma instância (Singleton)
  factory SqliteConnectionFactory() {
    return _instance;
  }

  // Método para abrir a conexão com o banco de dados
  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    var databasePathFinal = join(databasePath, _DATABASE_NAME);

    if (_database == null) {
      await _lock.synchronized(() async {
        if (_database == null) {
          _database = await openDatabase(
            databasePathFinal,
            version: _DATABASE_VERSION,
            onConfigure: _onConfigure,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onDowngrade: _onDowngrade,
          );
        }
      });
    }
    return _database!;
  }

  // Método para fechar a conexão com o banco de dados
  void closeConnection() {
    if (_database != null) {
      _database!.close();
      _database = null;
    }
  }

  // Configuração inicial do banco de dados
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Criação inicial do banco de dados
  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigration();
    for (var migration in migrations) {
      migration.create(batch);
    }
    await batch.commit();
  }

  // Atualização do banco de dados (quando há mudança de versão)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final Batch batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);
    for (var migration in migrations) {
      migration.update(batch);
    }
    await batch.commit();
  }

  // Downgrade do banco de dados (quando necessário)
  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    await _onUpgrade(db, oldVersion, newVersion);
  }
}
