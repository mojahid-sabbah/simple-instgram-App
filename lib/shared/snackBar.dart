// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

void ShowSnackBar(BuildContext context, String msg, int colorr) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Color(colorr),
    duration: const Duration(seconds: 5),
    content: Text(
      msg,
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
    ),
    // action: SnackBarAction(label: "exit" , onPressed: (){},),
  ));
}
