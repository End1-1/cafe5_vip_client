import 'package:cafe5_vip_client/utils/prefs.dart';
import 'package:flutter/material.dart';

class Dialogs {

  static Future<void> show(String text) async {
    return await showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: Prefs.navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: Text(prefs.appTitle()),
            contentPadding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
            content: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 10,
              ),
              actions: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK')),
                ],
          );
        });
  }
}
