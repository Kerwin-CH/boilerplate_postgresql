import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart';

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
}
