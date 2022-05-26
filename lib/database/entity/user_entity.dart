import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey()
  int? id;
  String userId;
  String name;

  User(this.id, this.userId,this.name);
}
