import 'package:flutter/material.dart';

class MTextFormField extends TextFormField {
  MTextFormField(
      {required TextEditingController controller,
      int maxLines = 1,
      int minLines = 1,
      bool readOnly = false,
      required String hintText})
      : super(
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            readOnly: readOnly,
            decoration: InputDecoration(
                label: Text(hintText),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(10)))));
}
