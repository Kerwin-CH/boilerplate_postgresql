// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _TaskBean implements Bean<Task> {
  final id = new StrField('id');
  final title = new StrField('title');
  final userId = new StrField('user_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        title.name: title,
        userId.name: userId,
      };
  Task fromMap(Map map) {
    Task model = new Task();

    model.id = adapter.parseValue(map['id']);
    model.title = adapter.parseValue(map['title']);
    model.userId = adapter.parseValue(map['user_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Task model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(title.set(model.title));
      ret.add(userId.set(model.userId));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(title.name)) ret.add(title.set(model.title));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50);
    st.addStr(title.name, length: 150);
    st.addStr(userId.name,
        foreignTable: userBean.tableName, foreignCol: 'id', length: 50);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Task model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<int> update(Task model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<Task> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Task> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Task>> findByUser(String userId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.userId.eq(userId));
    return findMany(find);
  }

  Future<List<Task>> findByUserList(List<User> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (User model in models) {
      find.or(this.userId.eq(model.id));
    }
    return findMany(find);
  }

  UserBean get userBean;
}

abstract class _UserBean implements Bean<User> {
  final id = new StrField('id');
  final password = new StrField('password');
  final name = new StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        password.name: password,
        name.name: name,
      };
  User fromMap(Map map) {
    User model = new User();

    model.id = adapter.parseValue(map['id']);
    model.password = adapter.parseValue(map['password']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(password.set(model.password));
      ret.add(name.set(model.name));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(password.name)) ret.add(password.set(model.password));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50);
    st.addStr(password.name, length: 50);
    st.addStr(name.name);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(User model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<int> update(User model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<User> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<User> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
