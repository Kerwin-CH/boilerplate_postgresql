import 'dart:io';
import 'package:jaguar_boilerplate_postgresql_server/bean/bean.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

main() async {
  final PgAdapter adapter =
      PgAdapter('jaguar_learn', username: 'postgres', password: 'dart_jaguar');
  await adapter.connect();

  var userBean = UserBean(adapter);
  var taskBean = TaskBean(adapter);

  await taskBean.drop();
  await userBean.drop();

  await userBean.createTable();
  await taskBean.createTable();

  exit(0);
}
