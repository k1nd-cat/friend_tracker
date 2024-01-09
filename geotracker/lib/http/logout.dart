import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class LogoutRestApi {
  Future<LogoutResponse> logout(String token) async {
    var logger = Logger();
    try {
      var url = Uri.parse('https://.../geotracker/user/logout');
      await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'token': token
        },
      );

      return LogoutResponse(null);
    } catch (e) {
      logger.d(e);
      return LogoutResponse('Unknown error');
    }
  }
}

class LogoutResponse {

  final String? error;

  LogoutResponse(this.error);
}

