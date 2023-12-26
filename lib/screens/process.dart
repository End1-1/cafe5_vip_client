import 'dart:async';

import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/screens/app/screen.dart';
import 'package:cafe5_vip_client/screens/process_start.dart';
import 'package:cafe5_vip_client/utils/global.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

class ProcessScreen extends AppScreen {
  ProcessScreen(super.model, {super.key}) {
    model.getProcessList();
  }

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
  var pending = 0;
  var inProgress = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.model.basketController.stream,
        builder: (builder, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          pending = 0;
          inProgress = 0;
          for (final o in snapshot.data) {
            if (o['f_state'] == 1) {
              inProgress++;
            } else {
              pending++;
            }
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blueAccent, Colors.blue])),
                    child: Text(
                      '${widget.model.tr('In progress')} $inProgress',
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
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.deepOrange, Colors.orange])),
                    child: Text(
                      '${widget.model.tr('Pending')} $pending',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ))
                ]),
                //ORDERS
                Expanded(
                    child: SingleChildScrollView(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      Expanded(
                          child: Container(
                              color: Colors.blue,
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (final o in snapshot.data ?? []) ...[
                                      if (o['f_state'] == 1) ...[
                                        processWidget(o),
                                        const Divider(
                                            color: Colors.white,
                                            height: 2,
                                            thickness: 2)
                                      ]
                                    ],
                                  ]))),
                      Expanded(
                          child: Container(
                              color: Colors.orange,
                              child: Column(children: [
                                for (final o in snapshot.data ?? []) ...[
                                  if (o['f_state'] != 1) ...[
                                    pendingWidget(o),
                                    const Divider(
                                        color: Colors.white,
                                        height: 2,
                                        thickness: 2)
                                  ]
                                ]
                              ]))),
                    ])))
              ]);
        });
  }

  Widget processWidget(Map<String, dynamic> o) {
    return InkWell(
        onTap: () {
          widget.model.endOrder(o);
        },
        child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: const BoxDecoration(color: Color(0xff94a5ba)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      o['f_tablename'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Expanded(child: Container()),
                    Icon(Icons.car_repair_outlined),
                    SizedBox(
                        width: 100,
                        child: Text(o['f_carnumber'],
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)))
                  ],
                ),
                Column(
                  children: [
                    for (final i in o['f_items'] ?? []) ...[
                      Row(
                        children: [
                          Text('${i['f_part2name']} ${i['f_dishname']}',
                              style: const TextStyle(color: Colors.black)),
                          Expanded(child: Container()),
                          Icon(Icons.access_time_rounded),
                          SizedBox(
                              width: 100,
                              child: Text(
                                  '${processDuration(i['f_begin'], i['f_cookingtime'], widget.model.tr('hour'), widget.model.tr('min'))}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)))
                        ],
                      )
                    ]
                  ],
                )
              ],
            )));
  }

  Widget pendingWidget(Map<String, dynamic> o) {
    return InkWell(
        onTap: () {
          ProcessStartScreen.show(o, widget.model);
        },
        child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            decoration: const BoxDecoration(color: Color(0xff94a5ba)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      o['f_tablename'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(o['f_carnumber'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    for (final i in o['f_items'] ?? []) ...[
                      Row(
                        children: [
                          Text('${i['f_part2name']} ${i['f_dishname']}')
                        ],
                      )
                    ]
                  ],
                )
              ],
            )));
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
