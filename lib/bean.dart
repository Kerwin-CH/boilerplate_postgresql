part of boilerplate_postgresql.api;

/// The bean
class TodoItemBean extends Bean<TodoItem> {
  static final StrField id = new StrField('id');

  static final StrField title = new StrField('title');

  static final BoolField finished = new BoolField('finished');

  /// Table name for the model this bean manages
  String get tableName => 'todos';

  TodoItemBean(Adapter adapter) : super(adapter);

  List<SetColumn> toSetColumns(TodoItem todo, [bool isUpdate = false]) {
    final ret = <SetColumn>[]
      ..add(title.set(todo.title))
      ..add(finished.set(todo.finished));
    if (!isUpdate) {
      ret.add(id.set(todo.id));
    }
    return ret;
  }

  TodoItem fromMap(Map map) => todoItemSerializer.fromMap(map);

  Future<Null> createTable() async {
    final st = new Create()
        .ifNotExists()
        .named(tableName)
        .addStr(id.name, primary: true, length: 50)
        .addStr(title.name, length: 100)
        .addBool(finished.name);

    await execCreateTable(st);
  }

  /// Inserts a new todoitem into table
  Future insert(TodoItem todo) async {
    final st = inserter.setMany(toSetColumns(todo));
    await execInsert(st);
  }

  /// Updates a todoitem
  Future update(TodoItem todo) async {
    final st = updater.where(id.eq(todo.id)).setMany(toSetColumns(todo, true));
    await execUpdate(st);
  }

  Future setFinished(String id) async {
    final st = updater.where(TodoItemBean.id.eq(id)).set(finished, true);
    await execUpdate(st);
  }

  Future setUnfinished(String id) async {
    final st = updater.where(TodoItemBean.id.eq(id)).set(finished, false);
    await execUpdate(st);
  }

  /// Finds one todoitem by [id]
  Future<TodoItem> findById(String id) async {
    final st = finder.where(TodoItemBean.id.eq(id));
    return execFindOne(st);
  }

  /// Finds all todoitems
  Future<List<TodoItem>> findAll() async {
    final st = finder;
    return await (await execFind(st)).toList();
  }

  /// Deletes a todoitem by [id]
  Future delete(String id) async {
    final st = remover.where(TodoItemBean.id.eq(id));
    await execRemove(st);
  }

  /// Deletes all todoitems
  Future deleteAll() async {
    final st = remover;
    await execRemove(st);
  }

  Future drop() async {
    final st = new Drop().named('todos').onlyIfExists();
    await adapter.dropTable(st);
  }
}
