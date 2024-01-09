import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:geotracker/utils/my_info.dart';
import 'package:path_provider/path_provider.dart';

class Login {
  final log = Logger();
  BuildContext? _context;

  Login();
  Login.withContext(this._context);

  void performLogin() {
    saveData();
    hideKeyboard();
    Navigator.of(_context!)
        .pushNamedAndRemoveUntil('/map_screen', (Route<dynamic> route) => false);
  }

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future<File> getFile() async {
    Directory tempDir = await getTemporaryDirectory();
    var file = File("${tempDir.path}/sample_file.txt");
    return file;
  }

  void saveData() async {
    if (!await isExistsFile()) {
      log.d("CREATING FILE");
      createFile();
    }
    writeInfoInFile();
  }

  Future<bool> isExistsFile() async {
    if (await (await getFile()).exists()) {
      return true;
    }
    log.d("FILE IS NOT EXISTS");
    return false;
  }

  Future<void> createFile() async {
    (await getFile()).create(
      recursive: false,
      exclusive: false,
    );
  }

  Future<void> writeInfoInFile() async {
    String info = MyInfo.toJson();
    (await getFile()).writeAsString(info);
  }

  Future<void> getInfoFromFile() async {
    try {
      var info = jsonDecode(await (await getFile()).readAsString());
      log.d("DATA: $info");
      MyInfo.login = info['login'];
      MyInfo.token = info['token'];
      MyInfo.name = info['name'];
      log.d("READ FROM FILE:\n\tlogin: ${MyInfo.login}\n\ttoken: ${MyInfo.token}\n\tname: ${MyInfo.name}");
    } catch(e) {
      log.d(e);
    }
  }

  Future<void> deleteFile() async {
    if (await isExistsFile()) {
      (await getFile()).delete(recursive: false);
    }
  }
}