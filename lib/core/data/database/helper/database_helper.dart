import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trackio/core/data/database/model/logs/logs_table.dart';
import 'package:trackio/core/data/database/model/user/user_table.dart';

class DatabaseHelper {
  // Class private constructor
  const DatabaseHelper._init();

  // Class singleton
  static const DatabaseHelper instance = DatabaseHelper._init();

  // Database object
  static Database? _database;

  // Initializing database for the first time
  Future<Database> getDatabase() async {
    _database ??= await createDatabase();
    return _database!;
  }

  // Creating database
  Future<Database> createDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    final String path = join(appDir.path, 'trackio.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(UserTable.createTable);
        await db.execute(LogsTable.createTable);
      },
      version: 1,
    );
  }
}
