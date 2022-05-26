import 'package:database_demo/database/database.dart';
import 'package:database_demo/database/entity/user_entity.dart';

class DataBaseManager {
  static Future<MyDataBase> database() async {
    final database =
        await $FloorMyDataBase.databaseBuilder('app_database.db').build();
    return database;
  }

  /// 查询
  static Future<List<User>> queryAllUser() async {
    var myDataBase = await database();
    return myDataBase.userDao.findAllUser();
  }

  /// 根据Id查询
  static Future<List<User>> queryUserById(String userId) async {
    var myDataBase = await database();
    return myDataBase.userDao.findAllUserById(userId);
  }

  /// 插入
  static Future<void> insertUser(User user) async {
    var myDataBase = await database();
    return await myDataBase.userDao.insertUser(user);
  }

  /// 更新 返回[int] 表示受影响的行数
  static Future<int> updateUser(User user) async {
    var myDataBase = await database();
    return await myDataBase.userDao.updateUser(user);
  }

  /// 删除 返回[int] 表示受影响的行数
  static Future<int> deleteUser(User user) async {
    var myDataBase = await database();
    return await myDataBase.userDao.deleteUser(user);
  }
}
