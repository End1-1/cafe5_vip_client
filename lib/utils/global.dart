import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget globalOutlinedButton({required VoidCallback onPressed, required String title}) {
  return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
alignment: Alignment.center,
          backgroundColor: Colors.indigo,
          shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(5.0)))),
      child: SizedBox.expand( child: Align(alignment: Alignment.center, child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ))));
}

Image imageFromBase64(String base64str, {double? width, double? height}) {
  Uint8List data = base64Decode(base64str);
  return Image.memory(data, width: width, height: height,);
}

String durationToString(int i, String h, String m) {
  int hour = i ~/ 60;
  int min = i % 60;
  return '${hour>0 ? '$hour$h' : '' } ${min>0 ? '$min$m' : ''}';
}

DateTime strToDateTime(String dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
}

String processDuration(String begin, int duration, String h, String m) {
  DateTime b = strToDateTime(begin);
  DateTime now = DateTime.now();
  Duration diff = now.difference(b);
  return durationToString(diff.inMinutes, h, m);
}

final RegExp doubleRegExp = RegExp(r'([.]*0)(?!.*\d)');

const kButtonHeight = 40.0;