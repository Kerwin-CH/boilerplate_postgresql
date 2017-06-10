import 'package:jaguar/jaguar.dart';
import 'package:boilerplate_postgresql/api.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:jaguar_query_postgresql/jaguar_query_postgresql.dart';

main() async {
  pg.Connection db = await pg.connect(postgreUrl);
  final PgAdapter adapter = new PgAdapter.FromConnection(db);
  TodoItemBean bean = new TodoItemBean(adapter);
  await bean.drop();
  await bean.createTable();

  final server = new Jaguar();
  server.addApi(reflectJaguar(new TodoApi()));
  await server.serve();
}