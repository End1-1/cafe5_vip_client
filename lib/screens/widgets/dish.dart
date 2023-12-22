import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dish extends StatelessWidget {
  final Map<String, dynamic> data;
  final AppModel model;

  const Dish(this.data, this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){},
    child: Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: model.screenSize!.width * 0.4,
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.blueAccent,
          border: Border.fromBorderSide(BorderSide(color: Colors.white10)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(children: [
        Text(data['f_name'],
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Row(children: [
          Expanded(child: Container()), Text('${data['f_price']}')
        ],)
      ]),
    )
    );
  }

}