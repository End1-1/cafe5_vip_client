import 'package:cafe5_vip_client/screens/app/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  final model = AppModel();

  AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Widget?>(
          stream: model.bodyController.stream, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(child: SizedBox(child: CircularProgressIndicator()));
            }
            return snapshot.data;
        },
        )
      ),
    );
  }

}