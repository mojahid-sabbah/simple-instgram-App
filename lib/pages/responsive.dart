// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:instagram_app/provider/usersProvider.dart';
import 'package:provider/provider.dart';

class responsive extends StatefulWidget {
  final Widget myWebScreen;
  final Widget myMobileScreen;
  const responsive(
      {super.key, required this.myWebScreen, required this.myMobileScreen});

  @override
  State<responsive> createState() => _responsiveState();
}

class _responsiveState extends State<responsive> {
  getDataFromDB() async {
    //      classname
    final userProvider userdaraPROv = Provider.of(context, listen: false);
    await userdaraPROv.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext, BoxConstraints) {
        if (BoxConstraints.maxWidth < 600) {
          return widget.myMobileScreen;
        } else {
          return widget.myWebScreen;
        }
      },
    );
  }
}
