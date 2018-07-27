import 'dart:html';
import 'dart:async';
import 'package:tasks_common/api.dart';
import 'package:tasks_common/models.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:http/browser_client.dart';

TextAreaElement get newTaskText => querySelector('.new-task-text');
DivElement get taskListEl => querySelector('#task-list');

DivElement createTaskElement(Task task) {
  return DivElement()
    ..classes.add('task-item')
    ..children.add(DivElement()
      ..text = task.title
      ..classes.add('task-title'))
    ..children.add(DivElement()
      ..text = 'X'
      ..classes.add('task-delete')
      ..onClick.listen((_) async {
        try {
          List<Task> tasks = await TasksApi.remove(task.id);
          displayTasks(tasks);
        } on ApiError catch(e) {
          // TODO
        }
      }));
}

void displayTasks(List<Task> tasks) {
  taskListEl.children.clear();
  for(Task task in tasks) taskListEl.children.add(createTaskElement(task));
}

Future<void> updateTasks() async {
  List<Task> tasks = await TasksApi.all();
  displayTasks(tasks);
}

main() async {
  globalClient = BrowserClient();

  updateTasks();
  newTaskText.onKeyUp.listen((KeyboardEvent ke) async {
    if (ke.keyCode == KeyCode.ENTER && ke.shiftKey) {
      try {
        List<Task> tasks = await TasksApi.add(newTaskText.value);
        displayTasks(tasks);
      } on ApiError catch(e) {
        // TODO
      }
    }
  });
}
