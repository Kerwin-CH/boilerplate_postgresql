// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library boilerplate_postgresql.api;

import 'dart:async';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_postgresql/jaguar_postgresql.dart';
import 'package:jaguar_query_postgresql/jaguar_query_postgresql.dart';
import 'package:ulid/ulid.dart';
import 'package:boilerplate_postgresql/model/model.dart';

part 'bean.dart';

const String postgreUrl = "postgres://postgres:dart_jaguar@localhost/todos";

@Api(path: '/api/todos')
@Wrap(const [#postgres])
class TodoApi {
  PostgresDb postgres(Context ctx) => new PostgresDb(postgreUrl);

  TodoItemBean mkBean(Context ctx) {
    final pg.Connection db = ctx.getInput<pg.Connection>(PostgresDb);
    final PgAdapter adapter = new PgAdapter.FromConnection(db);
    return new TodoItemBean(adapter);
  }

  @Get()
  Future<Response<String>> getAll(Context ctx) async {
    final TodoItemBean bean = mkBean(ctx);

    List<TodoItem> res = await bean.findAll();
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Get(path: '/:id')
  Future<Response<String>> getById(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = mkBean(ctx);

    TodoItem res = await bean.findOne(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Post()
  Future<Response<String>> insert(Context ctx) async {
    final Map body = await ctx.req.bodyAsJsonMap();
    final TodoItem todo = todoItemSerializer.fromMap(body);
    todo.finished = false;
    final TodoItemBean bean = mkBean(ctx);
    final String id = new Ulid().toUuid();
    todo.id = id;
    await bean.insert(todo);

    List<TodoItem> res = await bean.findAll();
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Put()
  Future<Response<String>> update(Context ctx) async {
    final Map body = await ctx.req.bodyAsJsonMap();
    final TodoItem todo = todoItemSerializer.fromMap(body);
    final TodoItemBean bean = mkBean(ctx);
    final String id = todo.id;
    await bean.update(todo);

    TodoItem res = await bean.findOne(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Put(path: '/:id/finished')
  Future<Response<String>> updateFinished(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = mkBean(ctx);
    await bean.setFinished(id);

    TodoItem res = await bean.findOne(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Put(path: '/:id/unfinished')
  Future<Response<String>> updateUnfinished(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = mkBean(ctx);
    await bean.setUnfinished(id);

    TodoItem res = await bean.findOne(id);
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Delete(path: '/:id')
  Future<Response<String>> deleteById(Context ctx) async {
    String id = ctx.pathParams['id'];
    final TodoItemBean bean = mkBean(ctx);
    await bean.delete(id);

    List<TodoItem> res = await bean.findAll();
    return Response.json(todoItemSerializer.serialize(res));
  }

  @Delete()
  Future<Response<String>> deleteAll(Context ctx) async {
    final TodoItemBean bean = mkBean(ctx);
    await bean.deleteAll();

    return Response.json(null);
  }
}
