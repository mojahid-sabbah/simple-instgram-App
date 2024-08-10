// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/screens.dart/profile.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 207, 206, 206),
          title: TextFormField(
            onChanged: (value) {
              setState(() {});
            },
            controller: searchController,
            decoration: const InputDecoration(
                labelText: "search for a user",
                labelStyle: TextStyle(
                  fontSize: 28,
                ),
                fillColor: Color.fromARGB(255, 181, 60, 60),
                focusColor: Colors.white),
          ),
        ),
        body: FutureBuilder(
          // future the data will store in snapshot
          future: FirebaseFirestore.instance
              .collection('instagramUsers')
              .where("userName", isEqualTo: searchController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data.docs.length == 0
                  ? const Center(
                      child: Text(
                      "Can`ّt found any User *_*!",
                      style: TextStyle(fontSize: 25),
                    ))
                  : ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => profile(
                                            currentuserID: snapshot.data.docs[0]
                                                ["uid"],
                                          )));
                            },
                            title: Text(snapshot.data.docs[0]["userName"]),
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                  "${snapshot.data.docs[0]["userImg"]}"),
                            ),
                          ),
                        );
                      });
            }

            return const Text("loading");
          },
        ));
  }
}
