import 'package:cafe5_vip_client/utils/global.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:cafe5_vip_client/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import 'app/model.dart';

class ProcessEndScreen {
  static void show(Map<String, dynamic> o, AppModel model) async {
    return await showDialog(context: Prefs.navigatorKey.currentContext!, builder: (BuildContext context) {
      return SimpleDialog(

      );
    });
  }
}

class _ProcessScreenWidget extends StatefulWidget {
  final Map<String, dynamic> o;
  final AppModel model;

  const _ProcessScreenWidget(this.o, this.model);

  @override
  State<StatefulWidget> createState() => _ProcessScreenWidgetState();
}

class _ProcessScreenWidgetState extends State<_ProcessScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: const BoxDecoration(color: Color(0xff94a5ba)),
          child: Column(
            children: [
              Row(
                children: [
                       Text(
                         widget.o['f_tablename'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(widget.o['f_carnumber'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ],
              ),
              Column(
                children: [
                  for (final i in widget.o['f_items'] ?? []) ...[
                    Row(
                      children: [
                        Text('${i['f_part2name']} ${i['f_dishname']}')
                      ],
                    )
                  ]
                ],
              )
            ],
          )),
      Row(
        children: [
          Expanded(child: Container()),
          SizedBox(
              width: 100,
              height: kButtonHeight,
              child: globalOutlinedButton(
                  onPressed: () {
                    if (widget.o['f_table'] == 0) {
                      return;
                    }
                    Dialogs
                        .question(widget.model.tr('Start order?'), widget.model)
                        .then((value) {
                      if (value ?? false) {
                        widget.model.startOrder(widget.o);
                        Navigator.pop(context);
                      }
                    });},
                  title: widget.model.tr('Start'))),
          const SizedBox(width: 10),
          SizedBox(
              width: 100,
              height: kButtonHeight,
              child: globalOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: widget.model.tr('Close'))),
          Expanded(child: Container()),
        ],
      )
    ]);
  }


}
