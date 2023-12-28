import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/utils/global.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

import 'dish_qty.dart';

class DishBasket extends StatelessWidget {
  final AppModel model;
  final Map<String, dynamic> data;
  final bool mode;

  const DishBasket(this.data, this.model, this.mode,
      { super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: Colors.indigo,
        width: model.screenSize!.width < 500 ? model.screenSize!.width * 0.9 : model.screenSize!.width * 0.45,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    height: model.screenSize!.width * model.screenMultiple,
                    width: model.screenSize!.width * model.screenMultiple,
                    child: data['f_image'].isEmpty
                        ? FittedBox(child: Icon(Icons.not_interested_outlined,
                            size: model.screenSize!.width * model.screenMultiple))
                        : imageFromBase64(data['f_image'],
                            width: model.screenSize!.width * model.screenMultiple)))
          ]),
          Text(data['f_name'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          Text(
            data['f_comment'],
            style: const TextStyle(
                color: Colors.white70, fontStyle: FontStyle.italic),
          ),
          if (data['f_comment'].isNotEmpty)
            const SizedBox(
              height: 10,
            ),
          if (data['f_cookingtime'] > 0) ...[
            Text(
              '${model.tr('Duration')}  ${durationToString(data['f_cookingtime'], model.tr('hour'), model.tr('min'))}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            )
          ],
          Row(
            children: [
              Text('${model.tr('Price')} ${data['f_price']}֏',
                  style: const TextStyle(color: Colors.white)),
              Expanded(child: Container())
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(children:[Expanded(child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
            Container(
              constraints: BoxConstraints(maxWidth: 200),
                child: DishQty( (q) {
                        data['f_qty'] = q;
                        model.appdata.setItemQty(data);
                      },
                data['f_qty'] ?? 1))])),

             Container(
                    constraints: BoxConstraints(maxWidth: 150),
                    height: kButtonHeight,
                    alignment: Alignment.center,
                    child: mode
                        ? globalOutlinedButton(
                            onPressed: () {
                              Navigator.pop(
                                  Prefs.navigatorKey.currentContext!, true);
                            },
                            title: model.tr('Add'))
                        : globalOutlinedButton(
                            onPressed: () {
                              model.appdata.removeBasketItem(data);
                            },
                            title: model.tr('Remove')))
          ])
        ]));
  }
}
