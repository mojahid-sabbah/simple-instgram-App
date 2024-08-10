// ignore_for_file: camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/fire_base%20services/firestore.dart';
import 'package:instagram_app/screens.dart/commentes.dart';
import 'package:instagram_app/shared/snackBar.dart';
import 'package:intl/intl.dart';

class postsDesign extends StatefulWidget {
  // current post
  final Map allDataFromDB;
  const postsDesign({super.key, required this.allDataFromDB});

  @override
  State<postsDesign> createState() => _postsDesignState();
}

class _postsDesignState extends State<postsDesign> {
  int counter = 0;

  getData() async {
    setState(() {});
    try {
      QuerySnapshot commentsData = await FirebaseFirestore.instance
          .collection("postsCollection")
          .doc(widget.allDataFromDB["postId"])
          .collection('commentsCollection') 
          .get();

      counter = commentsData.docs.length;
      setState(() {
        counter = commentsData.docs.length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    bool likes = widget.allDataFromDB["likes"]
        .contains(FirebaseAuth.instance.currentUser!.uid);

    return Container(
      margin: widthScreen > 600
          ? EdgeInsets.symmetric(horizontal: widthScreen / 4, vertical: 30)
          : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(122, 99, 27, 85),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.allDataFromDB["profileImg"],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            widget.allDataFromDB["username"],
                            style: const TextStyle(fontSize: 22),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    children: [
                                      // this icon of delete post we must check if this post for the current user or not << all post have the owner bost or who made the post (uId)    >>
                                      FirebaseAuth.instance.currentUser?.uid ==
                                              widget.allDataFromDB["uid"]
                                          ? SimpleDialogOption(
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        "postsCollection")
                                                    .doc(widget.allDataFromDB[
                                                        "postId"])
                                                    .delete();
                                                // ignore: use_build_context_synchronously
                                                ShowSnackBar(context,
                                                    "Post deleted", 0xFF49B369);
                                              },
                                              child: const Row(
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text("Delete this post")
                                                ],
                                              ),
                                            )
                                          : SimpleDialogOption(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Row(
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  Icon(
                                                    Icons.help_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text("Help")
                                                ],
                                              ),
                                            ),

                                      SimpleDialogOption(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.close),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text("Cancel")
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              Image.network(
                widget.allDataFromDB["imgPost"],
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
              ),
              Container(
                color: const Color.fromARGB(122, 99, 27, 85),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await fireStoreMethods().toggleLikes(
                                  likes: likes,
                                  allDataFromDB: widget.allDataFromDB);

                              setState(() {
                                likes = !likes;
                              });
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: likes ? Colors.red : Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => comments(
                                          allDataFromDB:
                                              widget.allDataFromDB)));
                            },
                            icon: const Icon(
                              Icons.comment,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_border,
                            size: 30,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.allDataFromDB["likes"].length}  ${widget.allDataFromDB["likes"].length > 1 ? "Likes" : "Like"}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.allDataFromDB["username"],
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.allDataFromDB["description"],
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => comments(
                                    allDataFromDB: widget.allDataFromDB)));
                      },
                      child: Text(
                        "veiw all $counter comments",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(DateFormat('MMMM d ,' 'y').format(
                        widget.allDataFromDB["datePublished"].toDate())),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
