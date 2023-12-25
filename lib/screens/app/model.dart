import 'dart:async';

import 'package:cafe5_vip_client/screens/basket.dart';
import 'package:cafe5_vip_client/screens/dishes.dart';
import 'package:cafe5_vip_client/screens/process.dart';
import 'package:cafe5_vip_client/screens/settings.dart';
import 'package:cafe5_vip_client/screens/welcome.dart';
import 'package:cafe5_vip_client/utils/http_query.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:cafe5_vip_client/widgets/dialogs.dart';
import 'package:cafe5_vip_client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'data.dart';

class AppModel {
  static const query_call_function = -1;
  static const query_init = 1;
  static const query_create_order = 2;
  static const query_procces_order = 3;

  final settingsServerAddressController = TextEditingController();
  final menuCodeController = TextEditingController();

  final basketController = StreamController.broadcast();
  final dialogController = StreamController();

  late final Data appdata;

  Size? screenSize;
  var screenMultiple = 0.3;

  AppModel() {
    appdata = Data(this);
    dialogController.stream.listen((event) {
      if (event is int) {
        Loading.show();
      } else if (event is String) {
        Dialogs.show(event);
      }
    });
  }

  void configScreenSize() {
    if (screenSize!.width >= 1240) {
      screenMultiple = 0.2;
    }
  }

  Future<void> initModel() async {
    final queryResult = await HttpQuery().request({
      'query': query_init,
      'params': <String, dynamic>{
        'f_menu': int.tryParse(prefs.string('menucode')) ?? 0
      }
    });
    if (queryResult['status'] == 1) {
      httpOk(query_init, queryResult['data']);
    } else {}
  }

  String tr(String key) {
    return key;
  }

  void navHome() {
    Navigator.pushAndRemoveUntil(
        Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => WelcomeScreen(this)),
        (r) => false);
  }

  void navSettings() {
    Dialogs.getPin().then((value) {
      if ((value ?? '') == '1981') {
        settingsServerAddressController.text = prefs.string('serveraddress');
        menuCodeController.text = prefs.string("menucode");
        Navigator.push(Prefs.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (builder) => SettingsScreen(this)));
      }
    });
  }

  void navProcess() {
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => ProcessScreen(this)));
  }

  void saveSettings() {
    prefs.setString("serveraddress", settingsServerAddressController.text);
    prefs.setString("menucode", menuCodeController.text);
    navHome();
  }

  void navDishes(filter) {
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => DishesScreen(this, filter)));
  }

  void navBasket() {
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => BasketScreen(this)));
  }

  void addToBasket(Map<String, dynamic> data) {
    data['f_uuid'] = const Uuid().v1().toString();
    appdata.basket.add(data);
    basketController.add(appdata.basket.length);
  }

  void processOrder() {
    List<Map<String, dynamic>> m = [];
    for (var e in appdata.basket) {
      final a = <String, dynamic>{};
      a.addAll(e);
      a.remove('f_image');
      m.add(a);
    }
    httpQuery(query_create_order, {
      'query': query_create_order,
      'params': <String, dynamic>{'items': m}
    });
  }

  void getProcessList() async {
    final queryResult = await HttpQuery().request({
      'query': query_call_function,
      'function': 'sf_get_process_list',
      'params': <String, dynamic>{
        'f_menu': int.tryParse(prefs.string('menucode')) ?? 0
      }
    });
    if (queryResult['status'] == 1) {
      httpOk(query_procces_order, queryResult['data']);
    } else {}
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
      case query_create_order:
        appdata.basket.clear();
        navHome();
        Dialogs.show(tr('Your order was created'));
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
