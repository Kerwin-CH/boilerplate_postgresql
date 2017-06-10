part of boilerplate_mongo.api;

class TodoItem {
  String id;

  String title;

  String message;

  bool finished;
}

@GenSerializer()
class TodoItemSerializer extends Serializer<TodoItem>
    with _$TodoItemSerializer {
  TodoItem createModel() => new TodoItem();
}

final TodoItemSerializer todoItemSerializer = new TodoItemSerializer();