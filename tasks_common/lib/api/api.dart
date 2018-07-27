import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:tasks_common/models.dart';

const baseUrl = 'http://localhost:8080/api';

class ApiError {
  final String message;
  final Set<String> fields;
  ApiError(this.message, Iterable<String> fields) : fields = Set.from(fields);
}

abstract class UserApi {
  static Future<ApiError> signup(String username, String password) async {
    ApiError error;
    await post(baseUrl)
        .path('/account/signup')
        .json({'username': username, 'password': password}).one(
            onError: (StringResponse resp) {
      Map map = resp.decode();
      error = ApiError(map['msg'], []);
    });
    return error;
  }

  static Future<ApiError> login(String username, String password) async {
    ApiError error;
    await post(baseUrl)
        .path('/account/login')
        .json({'username': username, 'password': password}).one(
            onError: (StringResponse resp) {
      Map map = resp.decode();
      error = ApiError(map['msg'], []);
    });
    return error;
  }

  static Future<ApiError> logout() async {
    ApiError error;
    await post(baseUrl).path('/account/logout').one(
        onError: (StringResponse resp) {
      Map map = resp.decode();
      error = ApiError(map['msg'], []);
    });
    return error;
  }
}

abstract class TasksApi {
  static Future<List<Task>> all() async {
    ApiError error;
    List<Task> tasks = await get(baseUrl).path('/tasks').list(
        convert: Task.serializer.fromMap,
        onError: (StringResponse resp) {
          Map map = resp.decode();
          error = ApiError(map['msg'], []);
        });
    if (error != null) throw error;
    return tasks;
  }

  static Future<List<Task>> add(String title) async {
    ApiError error;
    List<Task> tasks =
        await post(baseUrl).path('/tasks').json({'title': title}).list(
            convert: Task.serializer.fromMap,
            onError: (StringResponse resp) {
              Map map = resp.decode();
              error = ApiError(map['msg'], []);
            });
    if (error != null) throw error;
    return tasks;
  }

  static Future<List<Task>> removeAll() async {
    ApiError error;
    List<Task> tasks = await delete(baseUrl).path('/tasks').list(
        convert: Task.serializer.fromMap,
        onError: (StringResponse resp) {
          Map map = resp.decode();
          error = ApiError(map['msg'], []);
        });
    if (error != null) throw error;
    return tasks;
  }

  static Future<List<Task>> remove(String id) async {
    ApiError error;
    List<Task> tasks = await delete(baseUrl).path('/tasks/$id').list(
        convert: Task.serializer.fromMap,
        onError: (StringResponse resp) {
          Map map = resp.decode();
          error = ApiError(map['msg'], []);
        });
    if (error != null) throw error;
    return tasks;
  }
}
