import 'package:cafe5_vip_client/screens/app/screen.dart';
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
                        if (snapshot.data == null) {
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
                                child: Text(snapshot.data,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))));
                      })
                ]))),
        IconButton(
            onPressed: model.navSettings,
            icon: const Icon(Icons.settings_outlined))
      ],
    );
  }

  @override
  Widget body() {
    return Column(
      children: [
        Expanded(child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: [

            ],
          ),
        ))
      ],
    );
  }
}