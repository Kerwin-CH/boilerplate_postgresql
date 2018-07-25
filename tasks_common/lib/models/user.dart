import 'package:jaguar_common/jaguar_common.dart';

class User implements PasswordUser {
  String id;

  String name;

  String password;

  User({this.id, this.name, this.password});

  @override
  String get authorizationId => id;
}