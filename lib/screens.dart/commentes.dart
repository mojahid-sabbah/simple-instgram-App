// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/constants/textFields.dart';
import 'package:instagram_app/fire_base%20services/firestore.dart';
import 'package:instagram_app/provider/usersProvider.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class comments extends StatefulWidget {
  //allDataFromDB >> this posts data came from HOME page
  final Map allDataFromDB;
  const comments({super.key, required this.allDataFromDB});

  @override
  State<comments> createState() => _commentsState();
}

class _commentsState extends State<comments> {
  final commenttext = TextEditingController();
  @override
  void dispose() {
    commenttext.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<userProvider>(context).getUser;
    String? img = userData?.userImg;

    // userData>> this is the current user datas (loged in)
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: widthScreen > 600
          ? null
          : AppBar(
              backgroundColor: seconderyColor,
              title: const Text("Comments"),
            ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("postsCollection")
                  .doc(widget.allDataFromDB["postId"])
                  .collection('commentsCollection')
                  .orderBy(
                      "dataPuplish") // , descending: true عكس ترتيب العناصر تنازلي او تصاعدي
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      int textlength = data["textComment"].length;
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(20, 224, 146, 236),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data["profilePic"])),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textlength > 25
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data["userName"]
                                                // "mohamad",
                                                ,
                                                style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: 270,
                                                child: Text(
                                                  data["textComment"],
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                  maxLines: null,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                data["userName"]
                                                // "mohamad",
                                                ,
                                                style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  data["textComment"],
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                  maxLines: null,
                                                  overflow: TextOverflow.fade,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                    Text(
                                      DateFormat('MMMM d ,' 'y')
                                          .format(data["dataPuplish"].toDate()),
                                      // widget.allDataFromDB["username"],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_sharp,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(img!)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 7, 0),
                    child: myTextField(
                      mycontroller: commenttext,
                      validator: (value) {},
                      MyTextInputType: TextInputType.emailAddress,
                      isPassword: false,
                      hintTextt: "share your comment : ",
                      suffixIcon: IconButton(
                        onPressed: () async {
                          // we made here a comment collection as a feild in postdocument
                          await fireStoreMethods().addComments(
                              uID: userData!.uid,
                              textComment: commenttext.text,
                              postsID: widget.allDataFromDB["postId"],
                              userName: userData.userName,
                              profilePic: userData.userImg);

                          commenttext.clear();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF0569BA),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
