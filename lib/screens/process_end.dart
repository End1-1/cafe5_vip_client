import 'package:cafe5_vip_client/screens/widgets/payment.dart';
import 'package:cafe5_vip_client/utils/global.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:cafe5_vip_client/widgets/dialogs.dart';
import 'package:cafe5_vip_client/widgets/text_form_field.dart';
import 'package:flutter/material.dart';

import 'app/model.dart';

class ProcessEndScreen {
  static Future<bool?> show(Map<String, dynamic> o, AppModel model) async {
    return await showDialog(
        context: Prefs.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(10),
            children: [
              _ProcessScreenWidget(o, model),
            ],
          );
        }).then((value) async {
      if (value ?? false) {
        if (o['f_state'] == 1) {
          await model.httpQuery(AppModel.query_end_order, {
            'query': AppModel.query_call_function,
            'function': 'sf_end_order',
            'params': o
          });
          if ((o['f_amountcash'] ?? 0) + (o['f_amountcard'] ?? 0) + (o['f_amountidram'] ?? 0) > 0) {
            await model.httpQuery(AppModel.query_payment, {
              'query': AppModel.query_payment,
              'params': o
            });
          }
        } else {
          await model.httpQuery(AppModel.query_payment, {
            'query': AppModel.query_payment,
            'params': o
          });
        }
        return true;
      } else {
        model.getProcessList();
      }
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
  final durationController = TextEditingController();
  final moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    durationController.text = '${widget.o['f_items'].first['f_cookingtime']}';
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
                    ),
                    Row(
                      children: [
                        Text(widget.model.tr('End time')),
                        Expanded(child: Container()),
                        Text(dateTimeToTimeStr(widget.o['f_done']))
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (widget.o['f_state'] == 1)
                      Row(
                        children: [
                          Expanded(
                              child: MTextFormField(
                            controller: durationController,
                            hintText: widget.model.tr('Duration'),
                          )),
                          IconButton(
                              onPressed: () {
                                widget.o['duration'] = durationController.text;
                                widget.model.updateDuration(widget.o);
                              },
                              icon: const Icon(Icons.save_outlined))
                        ],
                      )
                  ]
                ],
              )
            ],
          )),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: Payment(widget.o, widget.model)),
      ]),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: Container()),
          SizedBox(
              width: 100,
              height: kButtonHeight,
              child: globalOutlinedButton(
                  onPressed: () {
                    Dialogs.question(
                            widget.model.tr('End order?'), widget.model)
                        .then((value) {
                      if (value ?? false) {
                        if (widget.o['f_state'] == 1) {
                          Navigator.pop(context, true);
                        } else {
                          if ((widget.o['f_amountcash'] ?? 0) +
                                  (widget.o['f_amountcard'] ?? 0) +
                                  (widget.o['f_amountidram'] ?? 0) <
                              (widget.o['f_amounttotal'] ?? 0)) {
                            Dialogs.show(
                                widget.model.tr('Select payment method'));
                          } else {
                            Navigator.pop(context, true);
                          }
                        }
                      }
                    });
                  },
                  title: widget.model.tr('Finish'))),
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
