import 'package:cafe5_vip_client/screens/app/screen.dart';
import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:cafe5_vip_client/widgets/text_form_field.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends AppScreen {
  const SettingsScreen(super.model, {super.key});


  @override
  Widget body() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Row(children:[
        Expanded(child: MTextFormField(controller: model.settingsServerAddressController, hintText: model.tr('Settings')))
    ]),
      const SizedBox(height: 10),
      Row(children:[
        Expanded(child: MTextFormField(controller: model.menuCodeController, hintText: model.tr('Menu code')))
      ])
    ],
  );
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
      title: Text(prefs.appTitle()),
      actions: [

        IconButton(
            onPressed: model.saveSettings,
            icon: const Icon(Icons.save_outlined))
      ],
    );
  }

}