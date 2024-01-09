import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class InviteAcceptRestApi {
  static const String inviteUrl = "https://.../geotracker/friend/invite";
  static const String acceptUrl = "https://.../geotracker/friend/accept";

  Future<InviteAcceptResponse> invite(String token, String login) async {
    return logic(inviteUrl, token, login);
  }

  Future<InviteAcceptResponse> accept(String token, String login) async {
    return logic(acceptUrl, token, login);
  }

  Future<InviteAcceptResponse> logic(String urlStr, String token, String login) async {
    var logger = Logger();
    try {
      var url = Uri.parse(urlStr);
      await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'token': token
        },
        body: jsonEncode(<String, String>{
          'login': login,
        }),
      );

      return InviteAcceptResponse(null);
    } catch (e) {
      logger.d(e);
      return InviteAcceptResponse('Unknown error');
    }
  }
}

class InviteAcceptResponse {
  final String? error;

  InviteAcceptResponse(this.error);
}