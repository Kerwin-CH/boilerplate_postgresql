import 'package:jaguar/jaguar.dart';
import 'package:boilerplate_postgresql/api.dart';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:jaguar_query_postgresql/jaguar_query_postgresql.dart';

import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main() async {
  pg.Connection db = await pg.connect(postgreUrl);
  final PgAdapter adapter = new PgAdapter.FromConnection(db);
  TodoItemBean bean = new TodoItemBean(adapter);
  await bean.drop();
  await bean.createTable();

  // Proxy all html client requests to pub server
  final proxy = new PrefixedProxyServer('/', 'http://localhost:8082/');

  final server = new Jaguar();
  server.addApiReflected((new TodoApi()));
  server.addApi(proxy);
  await server.serve();
}
