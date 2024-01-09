import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class CoordsRestApi {
  Future<SendCoordsResponse> sendCoords(String token, LatLng coords) async {
    var logger = Logger();
    try {
      var url = Uri.parse('https://.../geotracker/coords');
      http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'token': token
        },
        body: jsonEncode(<String, double> {
          'lat': coords.latitude,
          'lng': coords.longitude,
        }),
      );

      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      return SendCoordsResponse(responseBody['error']);
    } catch (e) {
      logger.d(e);
      return SendCoordsResponse('Unknown error');
    }
  }

  Future<FriendsCoordsResponse> getCoords(String token) async {
    var logger = Logger();
    try {
      var url = Uri.parse('https://.../geotracker/coords');
      http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'token': token
        },
      );

      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      logger.d("responseBody $responseBody");

      List<dynamic> friendsJson = responseBody;
      List<FriendCoords> parsedFriends = friendsJson.map((json) => FriendCoords.fromJson(json)).toList();

      logger.d("parsedFriends $parsedFriends");

      return FriendsCoordsResponse(parsedFriends, null);
    } catch (e) {
      logger.d(e);
      return FriendsCoordsResponse(null, 'Unknown error');
    }
  }
}

class SendCoordsResponse {

  final String? error;

  SendCoordsResponse(this.error);
}

class FriendsCoordsResponse {
  final List<FriendCoords>? friends;
  final String? error;

  FriendsCoordsResponse(this.friends, this.error);
}

class FriendCoords {
  final String? login;
  final String? userName;
  final double? lat;
  final double? lng;

  FriendCoords( {
    required this.login,
    required this.userName,
    required this.lat,
    required this.lng,
  });

  factory FriendCoords.fromJson(Map<String, dynamic> json) {
    return FriendCoords(
      login: json['login'] as String,
      userName: json['userName'] as String,
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }
}
