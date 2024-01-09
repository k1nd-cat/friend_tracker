import 'package:flutter/material.dart';
import '../logic/login_logic.dart';
import '../utils/styles.dart';
import 'signin_screen.dart';
import 'map_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State {

  Future<bool> isLoggingCompleted() async {
    if (await Login().isExistsFile()) {
      Login().getInfoFromFile();
      return true;
    }
    return false;
  }

  Widget firstScreenBuilder() {
    return FutureBuilder(
    future: isLoggingCompleted(),
    builder: (context, snapshot) {
      List<Widget> children;
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return const MapScreen();
          }
          return const SignInScreen();
        } else if (snapshot.hasError) {
          children = Style().loadingPage('Error: ${snapshot.error}');
        }
        else {
          children = Style().errorPage('Awaiting result...');
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return firstScreenBuilder();
  }
}