import 'package:sqflite/sqflite.dart';
import 'package:trackio/core/data/database/constants/user/user.dart';
import 'package:trackio/core/data/database/helper/database_helper.dart';

class UserDao {
  // Class private constructor
  const UserDao._init();

  // Creating singleton for class
  static const UserDao instance = UserDao._init();

  Future<Database> get database => DatabaseHelper.instance.getDatabase();

  /// Now performing crud operations

  // Registering User
  Future<bool> registerUser(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final db = await UserDao.instance.database;
    final dataInserted = await db.insert(User.tableName, {
      User.fullName: fullName,
      User.email: email,
      User.password: password,
      User.confirmPassword: confirmPassword,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    return dataInserted > 0;
  }

  // Login user
  Future<List<Map<String, dynamic>>> loginUser(String email) async {
    final db = await UserDao.instance.database;
    List<Map<String, dynamic>> getData = await db.query(
      User.tableName,
      where: "${User.email} = ?",
      whereArgs: [email],
    );
    return getData;
  }

  // Updating password
  Future<bool> updatePassword(
    String email,
    String newPassword,
    String confirmNewPassword,
  ) async {
    final db = await UserDao.instance.database;
    int updateData = await db.update(
      User.tableName,
      {User.password: newPassword, User.confirmPassword: confirmNewPassword},
      where: "${User.email} = ?",
      whereArgs: [email],
    );
    return updateData > 0;
  }

  // Update fullName
  Future<bool> updateFullName(String email, String newName) async {
    final db = await UserDao.instance.database;
    final int updateData = await db.update(
      User.tableName,
      {User.fullName: newName},
      where: "${User.email} = ?",
      whereArgs: [email],
    );
    return updateData > 0;
  }
}
