// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/screens.dart/Home.dart';
import 'package:instagram_app/screens.dart/addPost.dart';
import 'package:instagram_app/screens.dart/favorite.dart';
import 'package:instagram_app/screens.dart/profile.dart';
import 'package:instagram_app/screens.dart/search.dart';
//  flutter run -d edge --web-renderer html    // to run in web

class webPage extends StatefulWidget {
  const webPage({super.key});

  @override
  State<webPage> createState() => _webPageState();
}

class _webPageState extends State<webPage> {
  final PageController _pageController = PageController();
  int page = 0;
  navigate2screen(int Iconindex) {
    _pageController.jumpToPage(Iconindex);
    setState(() {
      page = Iconindex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: seconderyColor,
        actions: [
          IconButton(
            onPressed: () {
              navigate2screen(0);
            },
            icon: Icon(
              Icons.home,
              color: page == 0 ? Colors.white : secondColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigate2screen(1);
            },
            icon: Icon(
              Icons.search,
              color: page == 1 ? Colors.white : secondColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigate2screen(2);
            },
            icon: Icon(
              Icons.camera_alt_outlined,
              color: page == 2 ? Colors.white : secondColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigate2screen(3);
            },
            icon: Icon(
              Icons.favorite,
              color: page == 3 ? Colors.white : secondColor,
            ),
          ),
          IconButton(
            onPressed: () {
              navigate2screen(4);
            },
            icon: Icon(
              Icons.person,
              color: page == 4 ? Colors.white : secondColor,
            ),
          ),
        ],
        title: const Text("instagram"),
        //  Image.asset(
        //   "assets/img/Instagramlog.png",
        //   width: 120,
        //   color: Colors.white,
        // ),
      ),
      body: PageView(
        onPageChanged: (index) {},
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const Home(),
          const search(),
          const addPost(),
          const favorite(),
          profile(
            currentuserID: FirebaseAuth.instance.currentUser?.uid,
          ),
        ],
      ),
    );
  }
}
