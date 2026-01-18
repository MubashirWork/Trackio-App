import 'package:sqflite/sqflite.dart';
import 'package:trackio/core/data/database/constants/logs/logs.dart';
import 'package:trackio/core/data/database/helper/database_helper.dart';

class LogsDao {
  // Class private constructor
  const LogsDao._init();

  // Singleton
  static const LogsDao instance = LogsDao._init();

  Future<Database> get database => DatabaseHelper.instance.getDatabase();

  /// Now performing crud operation

  // Storing data
  Future<bool> storeData(
    String email,
    String date,
    String checkIn,
    String checkOut,
    String hours,
  ) async {
    final db = await LogsDao.instance.database;
    int dataInserted = await db.insert(Logs.tableName, {
      Logs.email: email,
      Logs.date: date,
      Logs.checkIn: checkIn,
      Logs.checkOut: checkOut,
      Logs.hours: hours,
    });
    return dataInserted > 0;
  }

  // Fetching data
  Future<List<Map<String, dynamic>>> fetchData(String email) async {
    final db = await LogsDao.instance.database;
    List<Map<String, dynamic>> getData = await db.query(
      Logs.tableName,
      where: "${Logs.email} = ?",
      whereArgs: [email],
    );
    return getData;
  }

  // Delete data
  Future deleteData(String email) async {
    final db = await LogsDao.instance.database;
    final int deleteData = await db.delete(
      Logs.tableName,
      where: "${Logs.email} = ?",
      whereArgs: [email],
    );
    return deleteData > 0;
  }
}