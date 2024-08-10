// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/pages/login.dart';
import 'package:instagram_app/screens.dart/postsDesigns.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/snackBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: widthScreen > 600
          ? null
          : AppBar(
              backgroundColor: seconderyColor,
              title: Image.asset(
                "assets/img/Instagramlog.png",
                width: 120,
                color: Colors.white,
              ),
              actions: [
                const Icon(Icons.message_outlined),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const login()),
                      );
                    } catch (e) {
                      ShowSnackBar(
                          context, "Error signing out: $e", 0xFFF4CC52);
                    }
                  },
                  icon: const Icon(Icons.logout_outlined),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
      body:
      
       StreamBuilder<QuerySnapshot>(
        //StreamBuilder it get data from DB
        stream: FirebaseFirestore.instance
            .collection('postsCollection')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // data is the DATAS that come from DB it has all data about post that we well need it in COMMENT page
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return postsDesign(
                allDataFromDB: data,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
