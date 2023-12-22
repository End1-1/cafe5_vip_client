import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

class Dialogs {
  late BuildContext dialogContext;

  Future<void> show(String text) async {
    showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: Prefs.navigatorKey.currentContext!,
        builder: (context) {
          dialogContext = context;
          return SimpleDialog(
            title: Text(prefs.appTitle()),
            contentPadding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            children: [
              Center(
                  child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 10,
              )),
              Row(
                children: [
                  Expanded(child: Container()),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK')),
                  Expanded(child: Container())
                ],
              )
            ],
          );
        });
  }
}
