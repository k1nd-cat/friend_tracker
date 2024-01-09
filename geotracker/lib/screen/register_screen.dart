import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../logic/login_logic.dart';
import '../utils/styles.dart';
import 'map_screen.dart';
import '../utils/my_info.dart';
import '../http/login_register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State {
  late String _name;
  late String _login;
  late String _password;
  final _formKey = GlobalKey<FormState>();

  Future<void> checkRegister(BuildContext context) async {
    var log = Logger();
    var registerResult = await LoginRegisterRestApi().register(_login, _password, _name);
    if (registerResult.error == null) {
      String? token = registerResult.token;
      if (token != null) MyInfo.token = token;
      MyInfo.name = registerResult.userName;
      MyInfo.login = registerResult.login;
      log.d('LOGIN INFO\n\ttoken: ${MyInfo.token}\n\tname: ${MyInfo.name}\n\tlogin${MyInfo.login}');
      Login.withContext(context).performLogin();
      // performRegister();
    } else {
      log.d("ERROR:\nlogin: $_login\npassword: $_password");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${registerResult.error}')),
      );
    }
  }

  void performRegister() {
    hideKeyboard();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/map_screen', (Route<dynamic> route) => false);
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void goToRegisterScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Style().standardAppBar("Register"),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: SizedBox(
                  width: 280,
                  height: 55,
                  child: TextFormField(
                    onChanged: (name) => _name = name,
                    decoration: Style().textFormFieldDecoration(context, "User name"),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: Style().textFormFieldTextStyle(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter user name';
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
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
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
                    decoration: Style().textFormFieldDecoration(context, "Repeat password"),
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: Style().textFormFieldTextStyle(),
                    validator: (value) {
                      if (value != _password) {
                        return 'Passwords don\'t match';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: ElevatedButton(
                  // onPressed: () { checkLogin(); },
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      checkRegister(context);
                    }
                  },
                  style: Style().elevatedButtonStyle(),
                  child: const Text('Register'),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}