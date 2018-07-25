import 'package:jaguar/jaguar.dart';
import 'package:boilerplate_postgresql/api/api.dart';
import 'package:postgres/postgres.dart' as pg;

import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main() async {
  // Proxy all html client requests to pub server
  final proxy = PrefixedProxyServer('/', 'http://localhost:8082/');

  final server = Jaguar();
  // TODO server.add(TaskRoutes());
  server.add(proxy);

  await server.serve();
}
