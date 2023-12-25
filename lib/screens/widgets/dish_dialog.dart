import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:cafe5_vip_client/screens/widgets/dish_basket.dart';
import 'package:cafe5_vip_client/utils/global.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

import 'dish_qty.dart';

class DishDialog {



  static void show(Map<String, dynamic> data, AppModel model) {
    data['f_qty'] = 1.0;
    showGeneralDialog(
        context: Prefs.navigatorKey.currentContext!,
        barrierDismissible: true,
        barrierLabel: '',
        transitionBuilder: (ctx, a1, a2, child) {
          var curve = Curves.easeInOut.transform(a1.value);
          return Transform.scale(
            scale: curve,
            child: SimpleDialog(
              backgroundColor: Colors.indigo,
              contentPadding: const EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              children: [
                DishBasket(data, model, true)
              ],
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, a1, a2) {
          return Container();
        }).then((value) {
      if (value != null) {
        model.addToBasket(data);
      }
    });
  }
}
