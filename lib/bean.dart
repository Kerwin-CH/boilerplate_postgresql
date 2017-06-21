part of boilerplate_postgresql.api;

/// The bean
class TodoItemBean extends Bean<TodoItem> {
  final StrField id = new StrField('id');

  final StrField title = new StrField('title');

  final BoolField finished = new BoolField('finished');

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
    final st = new CreateStatement()
        .ifNotExists()
        .named(tableName)
        .strCol(id.name, primary: true, length: 50)
        .strCol(title.name, length: 100)
        .boolCol(finished.name);

    await execCreateTable(st);
  }

  /// Inserts a new todoitem into table
  Future insert(TodoItem todo) async {
    final inserter = inserterQ.setMany(toSetColumns(todo));
    await execInsert(inserter);
  }

  /// Updates a todoitem
  Future update(TodoItem todo) async {
    final updater =
        updaterQ.where(this.id.eq(todo.id)).setMany(toSetColumns(todo, true));
    await execUpdate(updater);
  }

  Future setFinished(String id) async {
    final updater = updaterQ.where(this.id.eq(id)).set(finished.set(true));
    await execUpdate(updater);
  }

  Future setUnfinished(String id) async {
    final updater = updaterQ.where(this.id.eq(id)).set(finished.set(false));
    await execUpdate(updater);
  }

  /// Finds one todoitem by [id]
  Future<TodoItem> findOne(String id) async {
    final finder = finderQ.where(this.id.eq(id));
    return execFindOne(finder);
  }

  /// Finds all todoitems
  Future<List<TodoItem>> findAll() async {
    final finder = finderQ;
    return await (await execFind(finder)).toList();
  }

  /// Deletes a todoitem by [id]
  Future delete(String id) async {
    final deleter = deleterQ.where(this.id.eq(id));
    await execDelete(deleter);
  }

  /// Deletes all todoitems
  Future deleteAll() async {
    final deleter = deleterQ;
    await execDelete(deleter);
  }

  Future drop() async {
    final st = new DropTableStatement().named('todos').onlyIfExists();
    await adapter.dropTable(st);
  }
}
