import 'package:trackio/core/data/database/constants/logs/logs.dart';

class LogsTable {
  static const String createTable = '''
  CREATE TABLE ${Logs.tableName} (
    ${Logs.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Logs.email} TEXT, 
    ${Logs.sno} INTEGER,
    ${Logs.date} TEXT,
    ${Logs.checkIn} TEXT,
    ${Logs.checkOut} TEXT,
    ${Logs.hours} TEXT
  )
  ''';
}
