import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FriendsRestApi {
  static const String acceptedUrl = "https://.../geotracker/friend?confirmed=true";
  static const String waitingUrl = "https://.../geotracker/friend?confirmed=false";

  Future<FriendsResponse> accepted(String token) async {
    return logic(acceptedUrl, token);
  }

  Future<FriendsResponse> waiting(String token) async {
    return logic(waitingUrl, token);
  }

  Future<FriendsResponse> logic(String urlStr, String token) async {
    var logger = Logger();
    try {
      var url = Uri.parse(urlStr);
      http.Response response = await http.get(
        url,
        headers: <String, String> {
          'Content-Type': 'application/json',
          'token': token
        },
      );

      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      logger.d("responseBody $responseBody");

      List<dynamic> friendsJson = responseBody;
      List<Friend> parsedFriends = friendsJson.map((json) => Friend.fromJson(json)).toList();
      return FriendsResponse(parsedFriends, null);
    } catch (e) {
      logger.d(e);
      return FriendsResponse(null, 'Unknown error');
    }
  }
}

class FriendsResponse {
  final List<Friend>? friends;
  final String? error;

  FriendsResponse(this.friends, this.error);
}

class Friend {
  final String login;
  final String userName;

  Friend( {
    required this.login,
    required this.userName,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      login: json['login'] as String,
      userName: json['userName'] as String,
    );
  }

  String get name => userName;
}
