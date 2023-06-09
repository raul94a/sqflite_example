import 'package:sqflite_example/database/database_helper.dart';
import 'package:sqflite_example/models/user_model.dart';

class UserDao{
  final database = DatabaseHelper.instance.db;

  Future<List<UserModel>> readAll() async {
   final data = await database.query('users');
   return data.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<int> insert(UserModel user) async {
    return await database.insert('users', {'name': user.name});
  }
  Future<void> update(UserModel user) async {
    await database.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }
  Future<void> delete(UserModel user) async {
    await database.delete('users', where: 'id = ?', whereArgs: [user.id]);
  }
}