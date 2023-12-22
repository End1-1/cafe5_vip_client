import 'dart:async';

import 'package:cafe5_vip_client/main.dart';
import 'package:cafe5_vip_client/screens/settings.dart';
import 'package:cafe5_vip_client/screens/welcome.dart';
import 'package:cafe5_vip_client/utils/http_query.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:cafe5_vip_client/widgets/dialogs.dart';
import 'package:cafe5_vip_client/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppModel {
  final settingsServerAddressController = TextEditingController();

  final basketController = StreamController.broadcast();

  AppModel() {

  }

  Future<void> initModel() async {

  }

  String tr(String key) {
    return key;
  }

  void navHome() {
    Navigator.push(Prefs.navigatorKey.currentContext!, MaterialPageRoute(builder: (builder) => WelcomeScreen(this)));
  }

  void navSettings() {
    settingsServerAddressController.text = prefs.string('serveraddress');
    Navigator.pushAndRemoveUntil(Prefs.navigatorKey.currentContext!, MaterialPageRoute(builder: (builder) => SettingsScreen(this)), (r) => false);
  }

  void saveSettings() {
    prefs.setString("serveraddress", settingsServerAddressController.text);
    httpQuery(0, {}).then((value) {
      navHome();
    });
  }

  void navBasket() {

  }

  void httpOk(int code, dynamic data) {

  }

  void httpError(String text) async {

    Dialogs().show(text);
  }

  Future<void> httpQuery(int code, Map<String, dynamic> params) async {
    Loading l = Loading();
    l.show();

    final queryResult = await HttpQuery().request(params);
    //Navigator.pop(l.dialogContext);
    if (queryResult['status'] == 1) {
      httpOk(code, queryResult['data']);
    } else {
      httpError(queryResult['data']);
      Dialogs().show('text2');
    }
  }

}