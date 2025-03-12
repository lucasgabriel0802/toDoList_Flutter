import 'package:sqflite/sqlite_api.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration.dart';

class MigrationV3 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE todo3 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        date_time datetime NOT NULL,
        done integer
      )
    ''');
  }

  @override
  void update(Batch batch) {
    batch.execute('''
      CREATE TABLE todo3 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        date_time datetime NOT NULL,
        done integer
      )
    ''');
  }
}
