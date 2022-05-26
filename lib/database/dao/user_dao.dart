import 'package:database_demo/database/entity/user_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao{
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUser();

  @Query('SELECT * FROM User WHERE userId=:userId')
  Future<List<User>> findAllUserById(String userId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(User user);

  @update
  Future<int> updateUser(User user);

  @delete
  Future<int> deleteUser(User user);
}