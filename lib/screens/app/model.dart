import 'dart:async';
import 'dart:convert';

import 'package:cafe5_vip_client/screens/basket.dart';
import 'package:cafe5_vip_client/screens/car_number.dart';
import 'package:cafe5_vip_client/screens/dishes.dart';
import 'package:cafe5_vip_client/screens/help/screen_help.dart';
import 'package:cafe5_vip_client/screens/process.dart';
import 'package:cafe5_vip_client/screens/process_end.dart';
import 'package:cafe5_vip_client/screens/settings.dart';
import 'package:cafe5_vip_client/screens/welcome.dart';
import 'package:cafe5_vip_client/utils/global.dart';
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
  static const query_get_process_list = 3;
  static const query_end_order = 4;
  static const query_start_order = 5;
  static const query_update_duration = 6;
  static const query_reassign_table = 7;
  static const query_payment = 8;

  final titleController = TextEditingController();
  final settingsServerAddressController = TextEditingController();
  final configController = TextEditingController();
  final menuCodeController = TextEditingController();
  final modeController = TextEditingController();
  final carNumberController = TextEditingController();
  final showUnpaidController = TextEditingController();
  final tableController = TextEditingController();
  final afterBasketToOrdersController = TextEditingController();
  final messageController = TextEditingController();

  final basketController = StreamController.broadcast();
  final dialogController = StreamController();

  late final Data appdata;

  Size? _screenSize;
  Size screenSize() {
    if ((_screenSize?.width ?? 0) > 0) {
      return _screenSize!;
    }
    _screenSize = MediaQuery.sizeOf(Prefs.navigatorKey.currentContext!);
    configScreenSize();
    return screenSize();
  }
  var screenMultiple = 0.43;

  AppModel() {
    appdata = Data(this);
    dialogController.stream.listen((event) {
      if (event is int) {
        Loading.show();
      } else if (event is String) {
        if (event.isEmpty) {
          return;
        }
        Dialogs.show(event);
      }
    });
  }

  void configScreenSize() {
    if (_screenSize!.width > 500) {
      screenMultiple = 0.3;
    } else if (_screenSize!.width >= 1240) {
      screenMultiple = 0.2;
    }
  }

  Future<String> initModel() async {
    dialogController.add(1);
    final queryResult = await HttpQuery().request({
      'sql': "select sf_vip_init('${jsonEncode({
            'f_menu': int.tryParse(prefs.string('menucode')) ?? 0
          })}')",
    });
    Navigator.pop(Loading.dialogContext);
    if (queryResult['status'] == 1) {
      String s = queryResult['data']['data'][0][0];
      httpOk(query_init, jsonDecode(s));
      return '';
    } else {
      dialogController.add(queryResult['data']);
      return queryResult['data'];
    }
  }

  String tr(String key) {
    if (!appdata.translation.containsKey(key)) {
      appdata.translation[key] = {'f_en': key, 'f_am': key, 'f_ru': key};
      HttpQuery().request({
        'query': query_call_function,
        'function': 'sf_unknown_tr',
        'params': <String, dynamic>{'f_en': key}
      });
    }
    if (appdata.translation[key]!['f_am'].isEmpty) {
      return key;
    }
    return appdata.translation[key]!['f_am']!;
  }

  void navHome() {
    Navigator.pushAndRemoveUntil(
        Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => WelcomeScreen(this)),
        (r) => false);
  }

  void navHelp() {
    Navigator.pushAndRemoveUntil(
        Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => ScreenHelp(this)),
            (r) => false);
  }

  void navSettings() {
    Dialogs.getPin().then((value) {
      if ((value ?? '') == '1981') {
        settingsServerAddressController.text = prefs.string('serveraddress');
        menuCodeController.text = prefs.string('menucode');
        modeController.text = prefs.string('appmode');
        showUnpaidController.text = prefs.string('showunpaid');
        tableController.text = prefs.string('table');
        configController.text = prefs.string('config');
        titleController.text = prefs.string('title');
        afterBasketToOrdersController.text =
            prefs.string('afterbaskettoorders');
        Navigator.push(Prefs.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (builder) => SettingsScreen(this)));
      }
    });
  }

  void navProcess() {
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => ProcessScreen(this)));
  }

  void sendMessage() async {
    final queryResult = await HttpQuery().request({
      'sql': "select sf_create_message('${jsonEncode({
        'f_message': messageController.text,
        'f_table': prefs.string('table')
      })}')",
    });
    if (queryResult['status'] == 1) {
      messageController.clear();
      navHome();
      Dialogs.show('Ձեր հաղորդագրությունը ուղարկվել է');
    } else {
      Dialogs.show(queryResult['data']);
    }
  }

  void saveSettings() {
    prefs.setString('serveraddress', settingsServerAddressController.text);
    prefs.setString('menucode', menuCodeController.text);
    prefs.setString('appmode', modeController.text);
    prefs.setString('showunpaid', showUnpaidController.text);
    prefs.setString('table', tableController.text);
    prefs.setString('title', titleController.text);
    prefs.setString('config', configController.text);
    prefs.setString('afterbaskettoorders', afterBasketToOrdersController.text);
    initModel().then((value) {
      navHome();
    });
  }

  void navDishes(filter) {
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => DishesScreen(this, filter)));
  }

  void navBasketFromNumber() {
    if (carNumberController.text.length < 5) {
      Dialogs.show(tr('Car number incorrect'));
      return;
    }
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => BasketScreen(this)));
  }

  void navBasket() {
    if (prefs.string('appmode') == '1') {
      if (appdata.basket.isEmpty) {
        Dialogs.show(tr('Your basket is empty'));
        return;
      }
      Navigator.push(Prefs.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (builder) => CarNumberScreen(this)));
      return;
    }
    Navigator.push(Prefs.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (builder) => BasketScreen(this)));
  }

  void callStaff() {
    navHelp();
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
      'sql': "select sf_create_order('${jsonEncode({
            'order': appdata.basketData,
            'items': m,
            'f_staff': 1,
            'f_table': int.tryParse(prefs.string('table')) ?? 1,
            'car_number': carNumberController.text
          })}')",
    });
  }

  void getProcessList() async {
    final queryResult = await HttpQuery().request({
      'query': query_call_function,
      'sql': "select sf_get_process_list('${jsonEncode({'f_menu': int.tryParse(prefs.string('menucode')) ?? 0})}')"
    });
    if (queryResult['status'] == 1) {
      httpOk(query_get_process_list, jsonDecode(queryResult['data']['data'][0][0])['data']);
    } else {}
  }

  void startOrder(Map<String, dynamic> o) {
    httpQuery(query_start_order, {
      'query': query_call_function,
      'function': 'sf_start_order',
      'params': o
    });
  }

  void endOrder(Map<String, dynamic> o) {
    ProcessEndScreen.show(o, this).then((value) {
      if (value ?? false) {
        getProcessList();
      }
    });
  }

  void updateDuration(Map<String, dynamic> o) {
    httpQuery(query_update_duration, {
      'query': query_call_function,
      'function': 'sf_update_duration',
      'params': o
    });
  }

  void httpOk(int code, dynamic data) {
    switch (code) {
      case query_init:
        appdata.part1.clear();
        appdata.part2.clear();
        appdata.dish.clear();
        appdata.tables.clear();
        appdata.translation.clear();
        for (final e in data['part1'] ?? []) {
          appdata.part1.add(e);
        }
        for (final e in data['part2'] ?? []) {
          appdata.part2.add(e);
        }
        for (final e in data['dish'] ?? []) {
          appdata.dish.add(e);
        }
        for (final e in data['tables'] ?? []) {
          appdata.tables.add(e);
        }
        for (final e in data['translator'] ?? []) {
          appdata.translation[e['f_en']] = e;
        }
        break;
      case query_create_order:
        appdata.basket.clear();
        carNumberController.clear();
        if (prefs.string('afterbaskettoorders') == '1') {
          navProcess();
        } else {
          navHome();
        }
        Dialogs.show(tr('Your order was created'));
        break;
      case query_get_process_list:
        appdata.works.clear();
        for (final e in data) {
          appdata.works.add(e);
        }
        appdata.countWorksStartEnd();
        basketController.add(appdata.works);
        break;
      case query_end_order:
        getProcessList();
        break;
      case query_start_order:
        getProcessList();
        break;
    }
  }

  void correctJson(Map<String, dynamic> m) {
    for (var e in m.entries) {
      if (e.value is DateTime) {
        m![e.key] = dateTimeToStr(e.value);
      } else if (e.value is Map) {
        correctJson(e.value);
      } else if (e.value is List) {
        for (final l in e.value) {
          if (l is Map<String, dynamic>) {
            correctJson(l!);
          }
        }
      }
    }
  }

  Future<void> httpQuery(int code, Map<String, dynamic> params) async {
    dialogController.add(0);
    Map<String, dynamic> copy = {};
    copy.addAll(params);
    if (!copy.containsKey('params')) {
      copy['params'] = <String, dynamic>{};
    }
    correctJson(copy['params']);
    final queryResult = await HttpQuery().request(copy);
    Navigator.pop(Loading.dialogContext);
    if (queryResult['status'] == 1) {
      httpOk(code, queryResult['data']);
    } else {
      dialogController.add(queryResult['data']);
    }
  }
}
