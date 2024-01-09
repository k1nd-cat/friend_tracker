import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void performLogin(BuildContext context) {
  hideKeyboard();
  Navigator.of(context)
      .pushNamedAndRemoveUntil('/map_screen', (Route<dynamic> route) => false);
}