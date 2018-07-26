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

part 'tasks.dart';
part 'user.dart';

final pool = PostgresPool('example', password: 'dart_jaguar');

Future<void> pgInterceptor(Context ctx) => pool.injectInterceptor(ctx);