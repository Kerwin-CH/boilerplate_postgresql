// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserSerializer implements Serializer<User> {
  @override
  Map<String, dynamic> toMap(User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'name', model.name);
    return ret;
  }

  @override
  User fromMap(Map map) {
    if (map == null) return null;
    final obj = new User();
    obj.id = map['id'] as String;
    obj.name = map['name'] as String;
    return obj;
  }
}

abstract class _$TaskSerializer implements Serializer<Task> {
  @override
  Map<String, dynamic> toMap(Task model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'userId', model.userId);
    return ret;
  }

  @override
  Task fromMap(Map map) {
    if (map == null) return null;
    final obj = new Task();
    obj.id = map['id'] as String;
    obj.title = map['title'] as String;
    obj.userId = map['userId'] as String;
    return obj;
  }
}
