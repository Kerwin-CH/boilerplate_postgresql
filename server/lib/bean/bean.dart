import 'dart:async';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:tasks_common/tasks_common.dart';

part 'bean.jorm.dart';

@GenBean(
  columns: const {
    'id': PrimaryKey(length: 50),
    'userId': const BelongsTo(UserBean, length: 50, byHasMany: true),
  },
)
class TaskBean extends Bean<Task> with _TaskBean {
  final UserBean userBean;

  TaskBean(Adapter adapter)
      : userBean = UserBean(adapter),
        super(adapter);

  String get tableName => 'tasks';

  Future<bool> removeByIdAndUser(String id, String userId) async {
    int n = await adapter
        .remove(remover.where(this.id.eq(id) & this.userId.eq(userId)));
    return n != 0;
  }
}

@GenBean(
  columns: const {
    'id': PrimaryKey(length: 50),
    'password': Column(length: 50),
    'authorizationId': IgnoreColumn(),
  },
)
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter) : super(adapter);

  String get tableName => 'otm_simple_post';

  Future<User> byUsername(String name) =>
      findOne(finder.where(this.name.eq(name)));
}
