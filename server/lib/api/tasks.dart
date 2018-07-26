part of 'api.dart';

@Controller(path: '/tasks')
class TaskRoutes {
  Future<TaskBean> _makeBean(Context ctx) async {
    final pg.PostgreSQLConnection db = await pool.injectInterceptor(ctx);
    final adapter = PgAdapter.FromConnection(db);
    return TaskBean(adapter);
  }

  @PostJson()
  Future<Task> insert(Context ctx) async {
    // Authorize
    User user = await Authorizer.authorize<User>(ctx);

    // Parse body
    final Task task = await ctx.bodyAsJson(convert: Task.serializer.fromMap);

    // Make bean
    final TaskBean bean = await _makeBean(ctx);

    // Compose and insert new Task
    final String id = Ulid().toUuid();
    task.id = id;
    task.userId = user.id;
    await bean.insert(task);

    /// Fetch it
    return bean.find(id);
  }

  @GetJson()
  Future<List<Task>> getAll(Context ctx) async {
    User user = await Authorizer.authorize<User>(ctx);
    TaskBean bean = await _makeBean(ctx);
    return await bean.findByUser(user.id);
  }

  @DeleteJson(path: '/:id')
  Future<List<Task>> deleteById(Context ctx) async {
    User user = await Authorizer.authorize<User>(ctx);

    String id = ctx.pathParams['id'];
    final TaskBean bean = await _makeBean(ctx);
    await bean.removeByIdAndUser(id, user.id);
    return await bean.findByUser(user.id);
  }

  @Delete()
  Future<void> deleteAll(Context ctx) async {
    await Authorizer.authorize<User>(ctx);
    final TaskBean bean = await _makeBean(ctx);
    await bean.removeAll();
  }
}
