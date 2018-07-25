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
import '../bean/bean.dart';

final pool = PostgresPool('tasks', password: 'dart_jaguar');

Future<void> pgInterceptor(Context ctx) => pool.injectInterceptor(ctx);

@Controller(path: '/tasks')
class TaskRoutes {
  Future<TaskBean> _makeBean(Context ctx) async {
    final pg.PostgreSQLConnection db = await pool.injectInterceptor(ctx);
    final adapter = PgAdapter.FromConnection(db);
    return TaskBean(adapter);
  }

  /*
  @Get()
  Future<Response<String>> getAll(Context ctx) async {
    TaskBean bean = await _makeBean(ctx);

    List<Task> res = await bean.findAll();
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Get(path: '/:id')
  Future<Response<String>> getById(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = _makeBean(ctx);

    Task res = await bean.findById(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Post()
  Future<Response<String>> insert(Context ctx) async {
    final Map body = await ctx.req.bodyAsJsonMap();
    final Task todo = todoItemSerializer.fromMap(body);
    todo.finished = false;
    final TodoItemBean bean = _makeBean(ctx);
    final String id = new Ulid().toUuid();
    todo.id = id;
    await bean.insert(todo);

    Task res = await bean.findById(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Put()
  Future<Response<String>> update(Context ctx) async {
    final Map body = await ctx.req.bodyAsJsonMap();
    final Task todo = todoItemSerializer.fromMap(body);
    final TodoItemBean bean = _makeBean(ctx);
    final String id = todo.id;
    await bean.update(todo);

    Task res = await bean.findById(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Put(path: '/:id/finished')
  Future<Response<String>> updateFinished(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = _makeBean(ctx);
    await bean.setFinished(id);

    Task res = await bean.findById(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Put(path: '/:id/unfinished')
  Future<Response<String>> updateUnfinished(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = _makeBean(ctx);
    await bean.setUnfinished(id);

    Task res = await bean.findById(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Delete(path: '/:id')
  Future<Response<String>> deleteById(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = _makeBean(ctx);
    await bean.delete(id);

    List<Task> res = await bean.findAll();
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Delete()
  Future<Response<String>> deleteAll(Context ctx) async {
    final TodoItemBean bean = _makeBean(ctx);
    await bean.deleteAll();

    return Response.json(null);
  }
  */
}
