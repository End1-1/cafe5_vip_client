import 'dart:async';

import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/screens/app/screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.model.basketController.stream,
        builder: (builder, snapshot) {
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
                    decoration: const BoxDecoration(
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

  Widget pendingWidget(Map<String, dynamic> o) {
    return InkWell(onTap: (){
      widget.model.startOrder(o);
    }, child:Container(
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
              ],
            ),
            Column(
              children: [
                for (final i in o['f_items'] ?? []) ...[
                  Row(
                    children: [Text('${i['f_part2name']} ${i['f_dishname']}')],
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
