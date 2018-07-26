import 'package:jaguar_common/jaguar_common.dart';
import 'package:tasks_common/tasks_common.dart';

class User implements PasswordUser {
  String id;

  String name;

  String password;

  User({this.id, this.name, this.password});

  @override
  String get authorizationId => id;

  Map<String, dynamic> toJson() => serializer.toMap(this);

  static final serializer = UserSerializer();
}