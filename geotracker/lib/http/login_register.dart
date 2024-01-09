import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LoginRegisterRestApi {
  Future<LoginRegisterResponse> login(String login, String password) async {
    var logger = Logger();
    try {
      var url = Uri.parse('https://.../geotracker/user/login');
      http.Response response = await http.post(
        url,
        headers: <String, String>{
           'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, String> {
          'login': login,
          'password': password,
        }),
      );

      logger.d("response body ${utf8.decode(response.bodyBytes)}");

      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      return LoginRegisterResponse(responseBody['userName'], responseBody['login'], responseBody['token'], responseBody['error']);
    } catch (e) {
      logger.d(e);
      return LoginRegisterResponse(null, null, null, 'Unknown error');
    }
  }

  Future<LoginRegisterResponse> register(String login, String password, String userName) async {
    var logger = Logger();
    try {
      var url = Uri.parse('https://.../geotracker/user/register');
      http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'login': login,
          'password': password,
          'userName': userName,
        }),
      );
      var responseBody = jsonDecode(response.body);
      return LoginRegisterResponse(responseBody['userName'], responseBody['login'], responseBody['token'], responseBody['error']);
    } catch (e) {
      logger.d(e);
      return LoginRegisterResponse(null, null, null, 'Unknown error');
    }
  }
}

class LoginRegisterResponse {

  final String? userName;
  final String? login;
  final String? token;
  final String? error;

  LoginRegisterResponse(this.userName, this.login, this.token, this.error);
}