import 'dart:html';
import 'package:tasks_common/api.dart';
import 'package:http/browser_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

DivElement get submitBut => querySelector('#submit');
InputElement get usernameEl => querySelector('#username');
InputElement get passwordEl => querySelector('#password');
DivElement get errorsBox => querySelector('#errors');

void main() {
  globalClient = BrowserClient();
  submitBut.onClick.listen((_) async {
    String username = usernameEl.value;
    String password = passwordEl.value;
    ApiError error = await UserApi.login(username, password);
    if(error == null) {
      errorsBox.classes.add('hide');
      window.location.replace('/home/index.html');
      return;
    }
    errorsBox.text = error.message;
    errorsBox.classes.remove('hide');
  });
}