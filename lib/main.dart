import 'dart:convert';
import 'dart:io';

import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/screens/app/screen.dart';
import 'package:cafe5_vip_client/screens/welcome.dart';
import 'package:cafe5_vip_client/utils/http_overrides.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  HttpOverrides.global = MyHttpOverrides();

  prefs = await SharedPreferences.getInstance();
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    prefs.setString('pkAppName', appName);
    prefs.setString('pkAppVersion', '$version.$buildNumber');
  });
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  final AppModel _appModel = AppModel();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    _appModel.screenSize ??= MediaQuery.sizeOf(context);
    _appModel.configScreenSize();
    return MaterialApp(
      title: prefs.appTitle(),
      debugShowCheckedModeBanner: false,
      navigatorKey: Prefs.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(_appModel),
    );
  }

  void initialization() async {
    if (prefs.string("serveraddress").isEmpty) {
      FlutterNativeSplash.remove();
      return;
    }
    await _appModel.initModel();
    FlutterNativeSplash.remove();
    setState(() {

    });
  }
}