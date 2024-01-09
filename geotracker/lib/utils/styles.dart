import 'package:flutter/material.dart';

class Style {
  List<Widget> loadingPage(String text) {
    return <Widget>[
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(text),
      ),
    ];
  }

  List<Widget> errorPage(String text) {
    return const <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting result...'),
      ),
    ];
  }

  ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(280, 50),
      padding: const EdgeInsets.all(10),
    );
  }

  OutlineInputBorder textFormFieldEnabledBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.deepPurple.shade400),
      borderRadius: BorderRadius.circular(18.0),
      gapPadding: 2,
    );
  }

  TextStyle textFormFieldTextStyle() {
    return TextStyle(fontSize: 20, color: Colors.deepPurple.shade400);
  }

  InputDecoration textFormFieldDecoration(BuildContext context, String text) {
    return InputDecoration(
      labelText: text,
      border: Style().textFormFieldEnabledBorder(),
      labelStyle: MaterialStateTextStyle.resolveWith(
            (Set<MaterialState> states) {
          final Color color = states.contains(MaterialState.error)
              ? Theme.of(context).colorScheme.error
              : Colors.deepPurple.shade400;
          return TextStyle(color: color, letterSpacing: 1.3);
        },
      ),
      enabledBorder: Style().textFormFieldEnabledBorder(),
    );
  }

  TextStyle titleTextStyle() {
    return TextStyle(fontSize: 30, color: Colors.deepPurple.shade600,
        fontWeight: FontWeight.bold,
    );
  }

  AppBar standardAppBar(String text) {
    return AppBar(
      backgroundColor: const Color(0x00000000),
      elevation: 0,
      title: Text(text,
        style: titleTextStyle(),
      ),
      toolbarHeight: 55,
    );
  }
}