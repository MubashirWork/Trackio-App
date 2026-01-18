import 'package:trackio/core/data/database/constants/user/user.dart';

class UserTable {

  static const String createTable = '''
    CREATE TABLE ${User.tableName} (
      ${User.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${User.fullName} TEXT,
      ${User.email} TEXT UNIQUE,
      ${User.password} TEXT,
      ${User.confirmPassword} TEXT
    )
  ''';
}