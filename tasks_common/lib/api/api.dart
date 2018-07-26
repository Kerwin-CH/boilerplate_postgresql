import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart';

const baseUrl = 'http://localhost:8080/api';

abstract class UserApi {
  static Future<void> signup(String username, String password) async {
    // TODO add login on response
    Map response = await post(baseUrl)
        .path('/account/signup')
        .json({'username': username, 'password': password}).one();
  }

  static Future<void> login(String username, String password) async {
    // TODO add login on response
    Map response = await post(baseUrl)
        .path('/account/login')
        .json({'username': username, 'password': password}).one();
  }
}
