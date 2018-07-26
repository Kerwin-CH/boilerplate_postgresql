import 'package:tasks_common/tasks_common.dart';

class Task {
  String id;

  String userId;

  String title;

  Map<String, dynamic> toJson() => serializer.toMap(this);

  static final serializer = TaskSerializer();
}