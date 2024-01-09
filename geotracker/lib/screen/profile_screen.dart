import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:geotracker/utils/my_info.dart';
import 'package:geotracker/http/logout.dart';

import '../logic/login_logic.dart';
import '../utils/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State {
  var log = Logger();
  logout() async {
    var logoutResult = await LogoutRestApi().logout(MyInfo.token);
    if (logoutResult.error == null) {
      Login().deleteFile();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          '/login_screen', (Route<dynamic> route) => false);
    } else {
      log.d('LOGOUT ERROR: ${logoutResult.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        title: Text("Profile",
          style: Style().titleTextStyle(),
        ),
        toolbarHeight: 55,
          actions: <Widget>[
            IconButton(
              onPressed: () => logout(),
              icon: Icon (
                  Icons.login,
                  color: Colors.deepPurple.shade400,
                  size: 34.0
              ),
            ),
        ],
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 40),
              child: SizedBox(
                width: 400,
                child: Text(
                  "${MyInfo.name}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.deepPurple.shade400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding (
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 400,
                child: Text(
                  "${MyInfo.login}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}