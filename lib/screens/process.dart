import 'dart:async';

import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/screens/app/screen.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

class ProcessScreen extends AppScreen {
  const ProcessScreen(super.model, {super.key});

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: model.navHome,
        ),
        backgroundColor: Colors.green,
        toolbarHeight: kToolbarHeight,
        title: Text(prefs.appTitle()));
  }

  @override
  Widget body() {
    return _Body(model);
  }
}

class _Body extends StatefulWidget {
  final AppModel model;

  const _Body(this.model);

  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blueAccent, Colors.blue])),
                child: Text(
                  widget.model.tr('In progress'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.deepOrange, Colors.orange])),
                  child: Text(
                    widget.model.tr('Pending'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ))
          ]),
          Expanded(
              child:SingleChildScrollView(child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [])))
        ]);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 15), timerFunction);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void timerFunction(Timer t) {
    widget.model.getProcessList();
  }
}
