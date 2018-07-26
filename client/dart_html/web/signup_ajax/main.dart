import 'dart:html';
import 'package:tasks_common/api.dart';
import 'package:http/browser_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

DivElement get submitBut => querySelector('#submit');
InputElement get usernameEl => querySelector('#username');
InputElement get passwordEl => querySelector('#password');
DivElement get signupBox => querySelector('#signup-box');
DivElement get successBox => querySelector('#success-box');
DivElement get successMsgBox => querySelector('#success-message');

void main() {
  globalClient = BrowserClient();
  submitBut.onClick.listen((_) async {
    String username = usernameEl.value;
    String password = passwordEl.value;
    await UserApi.signup(username, password);
    successMsgBox.text = "Account for $username created successfully!";
    signupBox.classes.add('hide');
    successBox.classes.remove('hide');
  });
}
