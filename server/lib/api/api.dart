// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library boilerplate_postgresql.api;

import 'dart:async';
import 'package:postgres/postgres.dart' as pg;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_postgres/jaguar_postgres.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'package:ulid/ulid.dart';
import 'package:tasks_common/tasks_common.dart';
import 'package:jaguar_boilerplate_postgresql_server/bean/bean.dart';
import 'package:jaguar_auth/jaguar_auth.dart';
import '../bean/bean.dart';

export 'package:tasks_common/models.dart';

part 'tasks.dart';
part 'user.dart';

final pool = PostgresPool('jaguar_learn', password: 'dart_jaguar');

Future<void> pgInterceptor(Context ctx) => pool.injectInterceptor(ctx);

class MyUserFetcher extends UserFetcher<User> {
  Future<UserBean> _makeBean(Context ctx) async {
    final pg.PostgreSQLConnection db = await pool.injectInterceptor(ctx);
    final adapter = PgAdapter.FromConnection(db);
    return UserBean(adapter);
  }

  @override
  Future<User> byAuthenticationId(Context ctx, String authenticationId) async {
    UserBean bean = await _makeBean(ctx);
    return bean.findByUsername(authenticationId);
  }

  @override
  Future<User> byAuthorizationId(Context ctx, String authorizationId) async {
    UserBean bean = await _makeBean(ctx);
    return bean.find(authorizationId);
  }
}
