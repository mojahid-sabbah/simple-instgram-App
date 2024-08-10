// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:instagram_app/fire_base%20services/auth.dart';
import 'package:instagram_app/models/Usermodel.dart';

class userProvider with ChangeNotifier {
  UserModel? userData;
  UserModel? get getUser => userData;

  refreshUser() async {
    //                  call this function.............
    UserModel userdata = await Auth().getUserDetails();
    userData = userdata;
    notifyListeners();
  }
}
