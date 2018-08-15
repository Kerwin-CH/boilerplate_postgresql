import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_boilerplate_postgresql_server/api/api.dart';

import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main() async {
  final server = Jaguar();
  server.userFetchers[User] = MyUserFetcher();
  server.add(reflect(UserAccountRoutes()));
  server.add(reflect(TaskRoutes()));

  // Proxy all html client requests to pub server
  server.addRoute(getOnlyProxy('/*', 'http://localhost:8082/'));

  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
