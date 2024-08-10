// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:instagram_app/shared/colors.dart';

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: seconderyColor,
        title: const Text("favorite"),
      ),
    );
  }
}
