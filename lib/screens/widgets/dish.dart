import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/screens/widgets/dish_dialog.dart';
import 'package:cafe5_vip_client/utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dish extends StatelessWidget {
  final Map<String, dynamic> data;
  final AppModel model;

  const Dish(this.data, this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){
      DishDialog.show(data, model);
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      width: model.screenSize!.width * model.screenMultiple,
      height: (model.screenSize!.width * model.screenMultiple) + 120 ,
      decoration: const BoxDecoration(
          color: Colors.blueAccent,
          border: Border.fromBorderSide(BorderSide(color: Colors.white10)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                height: model.screenSize!.width * model.screenMultiple,
                width: model.screenSize!.width * model.screenMultiple,
                child: data['f_image'].isEmpty
                    ? FittedBox(child: Icon(Icons.not_interested_outlined,
                    size: model.screenSize!.width * model.screenMultiple))
                    : imageFromBase64(data['f_image'],
                    width: model.screenSize!.width * model.screenMultiple)),
        Text(data['f_name'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        Expanded(child: Container(),),
        Row(children: [
          Text('${model.tr('Price')} ${data['f_price']}֏', style: const TextStyle(color: Colors.white)), Expanded(child: Container())
        ],)
      ]),
    )
    );
  }

}