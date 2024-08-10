// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/screens.dart/Home.dart';
import 'package:instagram_app/screens.dart/addPost.dart';
import 'package:instagram_app/screens.dart/favorite.dart';
import 'package:instagram_app/screens.dart/profile.dart';
import 'package:instagram_app/screens.dart/search.dart';
import 'package:instagram_app/shared/colors.dart';

class mobileScreen extends StatefulWidget {
  const mobileScreen({super.key});

  @override
  State<mobileScreen> createState() => _mobileScreenState();
}

class _mobileScreenState extends State<mobileScreen> {
  final PageController _pageController = PageController();
  int currentIcon = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: 
          CupertinoTabBar(
            backgroundColor: seconderyColor,
            onTap: (index) {
              // navigate to the tabed page
              _pageController.jumpToPage(index);
              setState(() {
                currentIcon = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.home,
                      color: currentIcon == 0 ? primaryColor : secondColor,
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.search,
                      color: currentIcon == 1 ? primaryColor : secondColor,
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.add,
                      color: currentIcon == 2 ? primaryColor : secondColor,
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.favorite,
                      color: currentIcon == 3 ? primaryColor : secondColor,
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Icon(
                      Icons.person,
                      color: currentIcon == 4 ? primaryColor : secondColor,
                    ),
                  ),
                  label: ""),
            ]),
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
      ),
    );
  }
}
