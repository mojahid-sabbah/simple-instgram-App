// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class checkpassword extends StatelessWidget {
  final String msg;
  final Color? checkColor;

  const checkpassword({super.key, required this.msg, this.checkColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: checkColor,
              border:
                  Border.all(color: const Color.fromARGB(255, 189, 189, 189))),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(msg)
      ],
    );
  }
}
