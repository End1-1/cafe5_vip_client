import 'dart:async';

import 'package:cafe5_vip_client/screens/dishes.dart';
import 'package:cafe5_vip_client/screens/settings.dart';
import 'package:cafe5_vip_client/screens/welcome.dart';
import 'package:cafe5_vip_client/utils/http_query.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:cafe5_vip_client/widgets/dialogs.dart';
import 'package:cafe5_vip_client/widgets/loading.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class AppModel {
  static const query_init = 1;

  final settingsServerAddressController = TextEditingController();
  final menuCodeController = TextEditingController();

  final basketController = StreamController.broadcast();
  final dialogController = StreamController();

  final Data appdata = Data();
  Size? screenSize;

  AppModel() {
    dialogController.stream.listen((event) {
      if (event is int) {
        Loading.show();
      } else if (event is String) {
        Dialogs.show(event);
      }
    });
  }

  Future<void> initModel() async {
    final queryResult = await HttpQuery().request({
      'query': query_init,
      'menucode': int.tryParse(prefs.string('menucode')) ?? 0
    });
    if (queryResult['status'] == 1) {
      httpOk(query_init, queryResult['data']);
    } else {

    }
  }

  String tr(String key) {
    return key;
  }

  void navHome() {
    Navigator.pushAndRemoveUntil(Prefs.navigatorKey.currentContext!, MaterialPageRoute(builder: (builder) => WelcomeScreen(this)), (r) => false);
  }

  void navSettings() {
    settingsServerAddressController.text = prefs.string('serveraddress');
    menuCodeController.text = prefs.string("menucode");
    Navigator.push(Prefs.navigatorKey.currentContext!, MaterialPageRoute(builder: (builder) => SettingsScreen(this)));
  }

  void saveSettings() {
    prefs.setString("serveraddress", settingsServerAddressController.text);
    prefs.setString("menucode", menuCodeController.text);
    navHome();
  }

  void navDishes(filter) {
    Navigator.push(Prefs.navigatorKey.currentContext!, MaterialPageRoute(builder: (builder) => DishesScreen(this, filter)));
  }

  void navBasket() {

  }


  void httpOk(int code, dynamic data) {
    switch (code) {
      case query_init:
        for (final e in data['part1']) {
          appdata.part1.add(e);
        }
        for (final e in data['part2']) {
          appdata.part2.add(e);
        }
        for (final e in data['dish']) {
          appdata.dish.add(e);
        }
        break;
    }
  }

  Future<void> httpQuery(int code, Map<String, dynamic> params) async {
    dialogController.add(0);
    final queryResult = await HttpQuery().request(params);
    Navigator.pop(Loading.dialogContext);
    if (queryResult['status'] == 1) {
      httpOk(code, queryResult['data']);
    } else {
      dialogController.add(queryResult['data']);
    }
  }

}