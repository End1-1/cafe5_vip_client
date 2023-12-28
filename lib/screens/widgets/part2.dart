import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/utils/global.dart';
import 'package:flutter/material.dart';

class Part2 extends StatelessWidget {
  final Map<String, dynamic> data;
  final AppModel model;

  Part2(this.data, this.model);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          model.navDishes(data['f_id']);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: model.screenSize!.width * model.screenMultiple,
          height: (model.screenSize!.width * model.screenMultiple) + 150,
          decoration: const BoxDecoration(
              color: Colors.blueAccent,
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.white10, width: 2)),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Container(
              clipBehavior:  Clip.hardEdge,
              padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
                height: model.screenSize!.width * model.screenMultiple,
                width: model.screenSize!.width * model.screenMultiple,
                child: data['f_image'].isEmpty
                    ? FittedBox(child: Icon(Icons.not_interested_outlined,
                        size: model.screenSize!.width * model.screenMultiple))
                    : FittedBox(child: imageFromBase64(data['f_image'],
                        width: model.screenSize!.width * model.screenMultiple,
                    height: model.screenSize!.width * model.screenMultiple))),
            Expanded(child: Center(child: Text(data['f_name'],
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18))))
          ]),
        ));
  }
}
