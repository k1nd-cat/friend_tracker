import 'dart:convert';

class MyInfo {
  static String token = "";
  static String? name;
  static String? login;

  static String toJson() => <String, String> {
    jsonEncode('token') : jsonEncode(token),
    jsonEncode('name') : jsonEncode(name!),
    jsonEncode('login') : jsonEncode(login!)
    }.toString();
}