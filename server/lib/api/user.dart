// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library boilerplate_postgresql.api;

import 'dart:async';
import 'package:postgres/postgres.dart' as pg;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_postgres/jaguar_postgres.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'package:ulid/ulid.dart';
import 'package:tasks_common/models.dart';
import 'package:boilerplate_postgresql/bean/bean.dart';
import 'package:jaguar_auth/jaguar_auth.dart';

import '../bean/bean.dart';

final pool = PostgresPool('tasks', password: 'dart_jaguar');

Future<void> pgInterceptor(Context ctx) => pool.injectInterceptor(ctx);

// TODO load this from environment variable
final pwdHasher =
    MD5Hasher('kljdf83dflkgjdöloit49t45849turdklgsjöldf3459p809sdlkxjbvlkzdjs');

@Controller(path: '/account')
class TaskRoutes {
  Future<UserBean> _makeBean(Context ctx) async {
    final pg.PostgreSQLConnection db = await pool.injectInterceptor(ctx);
    final adapter = PgAdapter.FromConnection(db);
    return UserBean(adapter);
  }

  @Post(path: '/signup')

  /// Signup endpoint
  Future<void> signup(Context ctx) async {
    Map<String, String> form = await ctx.bodyAsUrlEncodedForm();

    String username = form['username'];
    String password = form['password'];

    // TODO validate

    UserBean bean = await _makeBean(ctx);
    final user = User(name: username, password: pwdHasher.hash(password));
    await bean.insert(user);
  }

  @Post(path: '/login')
  Future<void> login(Context ctx) async {
    Map<String, String> form = await ctx.bodyAsUrlEncodedForm();

    String username = form['username'];
    String password = form['password'];

    UserBean bean = await _makeBean(ctx);

    User user = await bean.byUsername(username);

    if (user == null) throw Response(null, statusCode: 401);
    if (user.password != pwdHasher.hash(password))
      throw Response(null, statusCode: 401);

    Session session = await ctx.session;
    session.add('uid', username);
  }

  @Post(path: '/logout')
  Future<void> logout(Context ctx) async {
    Session session = await ctx.session;
    session.remove('uid');
  }
}
