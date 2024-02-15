import 'package:cafe5_vip_client/screens/app/screen.dart';
import 'package:cafe5_vip_client/screens/widgets/part2.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends AppScreen {
  const WelcomeScreen(super.model, {super.key});

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.home_outlined),
        onPressed: model.navHome,
      ),
      backgroundColor: Colors.green,
      toolbarHeight: kToolbarHeight,
      title: Text(prefs.appTitle()),
      actions: [
        Container(padding: const EdgeInsets.fromLTRB(0, 0, 10, 0), child: Text(prefs.string('table'), style: const TextStyle(color: Colors.white))),
        IconButton(
            onPressed: model.callStaff, icon: const Icon(Icons.help_outline_rounded)),
        IconButton(
            onPressed: model.navBasket,
            icon: SizedBox(
                width: 24,
                height: 24,
                child: Stack(alignment: Alignment.center, children: [
                  const Icon(Icons.shopping_basket_outlined),
                  StreamBuilder(
                      stream: model.basketController.stream,
                      builder: (builder, snapshot) {
                        if (model.appdata.basket.isEmpty) {
                          return Container();
                        }
                        return Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text('${model.appdata.basket.length}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))));
                      })
                ]))),
        PopupMenuButton(
          icon: const Icon(Icons.settings_outlined),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                  child: ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(model.tr('Options')),
                onTap: model.navSettings,
              )),
              PopupMenuItem(
                  child: ListTile(
                leading: const Icon(Icons.monitor),
                title: Text(model.tr('Process')),
                onTap: model.navProcess,
              ))
            ];
          },
        )
      ],
    );
  }

  @override
  Widget body() {
    return Column(
      children: [
        Text(model.screenSize().width.toString()),
        Expanded(
            child: SingleChildScrollView(
          child: Align(
              alignment: Alignment.center,
              child: Column(children: [
                for (final p1 in model.appdata.part1List()) ...[
                  Row(children: [
                    Expanded(child: Container(
                      child: Text(p1['f_name'], textAlign: TextAlign.center,  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                    ))
                  ],),
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      for (final e in model.appdata.part2List(p1['f_id'])) ...[Part2(e, model)]
                    ],
                  )
                ]
              ])),
        ))
      ],
    );
  }
}
