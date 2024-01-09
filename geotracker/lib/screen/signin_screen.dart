import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:geotracker/screen/register_screen.dart';
import 'package:geotracker/utils/my_info.dart';
import 'package:geotracker/http/login_register.dart';
import 'package:geotracker/utils/styles.dart';

import '../logic/login_logic.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() {
    return SignInScreenState();
  }
}

class SignInScreenState extends State<SignInScreen> {
  late String _login;
  late String _password;
  final _formKey = GlobalKey<FormState>();

  Future<void> checkLogin(BuildContext context) async {
    var log = Logger();
    var loginResult = await LoginRegisterRestApi().login(_login, _password);
    if (loginResult.error == null) {
      String? token = loginResult.token;
      if (token != null) MyInfo.token = token;
      MyInfo.name = loginResult.userName;
      MyInfo.login = loginResult.login;
      log.d('CURRENT ACCOUNT:\n\ttoken: ${MyInfo.token}\n\tname: ${MyInfo.name}\n\tlogin: ${MyInfo.login}');
      log.d('MY INFO TO JSON ${MyInfo.toJson().toString()}');
      Login.withContext(context).performLogin();
    } else {
      log.d("LOGIN ERROR:\nlogin: $_login\npassword: $_password");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loginResult.error}')),
      );
    }
  }

  void performLogin() {
    hideKeyboard();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/map_screen', (Route<dynamic> route) => false);
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void goToRegisterScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Style().standardAppBar("Sign in"),
      body: Form(
        key: _formKey,
        child: Center (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 280,
                  height: 55,
                  child: TextFormField(
                    onChanged: (login) => _login = login,
                    decoration: Style().textFormFieldDecoration(context, "Login"),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: Style().textFormFieldTextStyle(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter login';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: SizedBox(
                    width: 280,
                    height: 55,
                    child: TextFormField(
                      onChanged: (password) => _password = password,
                      decoration: Style().textFormFieldDecoration(context, "Password"),
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: Style().textFormFieldTextStyle(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      checkLogin(context);
                    }
                  },
                  style: Style().elevatedButtonStyle(),
                  child: const Text('Login'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: MaterialButton(
                  onPressed: () => goToRegisterScreen(),
                  child: Text('Aren\'t registered?',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple.shade200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}