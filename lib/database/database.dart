
// 必须的包
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:database_demo/database/dao/user_dao.dart';
import 'package:database_demo/database/entity/user_entity.dart';

part 'database.g.dart';

// 执行命令 flutter pub run build_runner build --delete-conflicting-outputs
@Database(version: 1, entities: [User])
abstract class MyDataBase extends FloorDatabase{
  UserDao get userDao;
}
