import 'package:flutter/material.dart';
import 'package:geotracker/screen/map_screen.dart';
import 'screen/signin_screen.dart';
import 'screen/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/map_screen': (context) => const MapScreen(),
        '/login_screen': (context) => const SignInScreen(),
      },
    );
  }
}