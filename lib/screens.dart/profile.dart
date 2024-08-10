// ignore_for_file: use_build_context_synchronously, camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/pages/login.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/snackBar.dart';

class profile extends StatefulWidget {
  final dynamic currentuserID;
  const profile({super.key, required this.currentuserID});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Map userData = {};
  bool isloading = true;
  late int following;
  late int followers;
  late int postsLength;
  late bool isFollow;

  getData() async {
    setState(() {
      isloading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("instagramUsers")
          .doc(widget.currentuserID)
          .get();

      //   userData >>> this map has all data that get from Firebase Firestore for currentuser  ...
      userData = snapshot.data()!;
      following = userData["following"].length;
      followers = userData["followers"].length;
      isFollow = userData["followers"].contains(FirebaseAuth.instance.currentUser?.uid);

      dynamic snapshotposts = await FirebaseFirestore.instance
          .collection('postsCollection')
          .where("uid", isEqualTo: widget.currentuserID)
          .get();
      postsLength = snapshotposts.docs.length;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return isloading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: seconderyColor,
              title: Text(userData["userName"]),
            ),
            // ignore: prefer_const_constructors
            body: Container(
              margin: widthScreen > 600
                  ? EdgeInsets.symmetric(
                      horizontal: widthScreen / 4, vertical: 30)
                  : null,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData["userImg"]
                                // "assets/img/alquds2.jpg",
                                ),
                            radius: 45,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              postsLength.toString(),
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "post",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              followers.toString(),
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "followers",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              following.toString(),
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "following",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          0,
                          0,
                          0,
                        ),
                        child: Text(
                          userData["Bio"],
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 78, 78, 78),
                    thickness: 0.5,
                  ),
                  widget.currentuserID == FirebaseAuth.instance.currentUser?.uid
                      ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const login()),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text(
                                  "Edit profile",
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(12)),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(
                                            129, 187, 84, 231)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const login()),
                                    );
                                  } catch (e) {
                                    ShowSnackBar(context,
                                        "Error signing out: $e", 0xFFF4CC52);
                                    //  print("Error signing out: $e");
                                  }
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text(
                                  "Log out",
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.all(12)),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(255, 206, 65, 46)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                              ),
                            ],
                          ),
                        )
                      : isFollow == true
                          ? ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isFollow = !isFollow;
                                  });

                                  await FirebaseFirestore.instance
                                      .collection("instagramUsers")
                                      .doc(widget.currentuserID)
                                      .update({
                                    "followers": FieldValue.arrayRemove([
                                      FirebaseAuth.instance.currentUser?.uid
                                    ])
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("instagramUsers")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .update({
                                    "following": FieldValue.arrayRemove(
                                        [widget.currentuserID])
                                  });
                                } catch (e) {
                                  ShowSnackBar(context, "Error signing out: $e",
                                      0xFFF4CC52);
                                  //  print("Error signing out: $e");
                                }
                              },
                              icon: const Icon(Icons.phonelink_erase),
                              label: const Text(
                                "UnFollow",
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(12)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 206, 73, 46)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            )
                          : ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isFollow = !isFollow;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("instagramUsers")
                                      .doc(widget.currentuserID)
                                      .update({
                                    "followers": FieldValue.arrayUnion([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ])
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("instagramUsers")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "following": FieldValue.arrayUnion(
                                        [widget.currentuserID])
                                  });
                                } catch (e) {
                                  ShowSnackBar(
                                      context, "Error catch : $e", 0xFFF4CC52);
                                  //  print("Error signing out: $e");
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(
                                "Follow",
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.all(12)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 59, 46, 206)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                            ),
                  const Divider(
                    color: Color.fromARGB(255, 78, 78, 78),
                    thickness: 0.5,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('postsCollection')
                        .where("uid", isEqualTo: widget.currentuserID)
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // sanpshot it has all my datas
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }

                      // if (snapshot.hasData && !snapshot.data!.exists) {
                      //   return Text("Document does not exist");
                      // }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // عدد الاعمدة
                                        childAspectRatio:
                                            3 / 2, //نسبة الطول للعرض
                                        crossAxisSpacing:
                                            10, // المسافة بين العمودين
                                        mainAxisSpacing:
                                            33 // المسافة بين الصفوف
                                        ),
                                itemCount: snapshot.data.docs.length,
                                // snapshot.data.docs >> return a LIST of my docs in DB
                                itemBuilder: (BuildContext context, int index) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      snapshot.data.docs[index]["imgPost"],
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: double.infinity,
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
