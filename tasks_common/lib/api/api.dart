import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart';

const baseUrl = 'http://localhost:10000/api';

abstract class UserApi {
  Future<void> signup(String username, String password) async {
    // TODO add login on response
    Map response = await post(baseUrl)
        .path('/signup')
        .urlEncodedForm({'username': username, 'password': password}).one();
  }

  Future<void> login(String username, String password) async {
    // TODO add login on response
    Map response = await post(baseUrl)
        .path('/login')
        .urlEncodedForm({'username': username, 'password': password}).one();
  }
}
