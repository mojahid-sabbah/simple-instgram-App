// ignore_for_file: non_constant_identifier_names, camel_case_types, avoid_print

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/fire_base%20services/firestore.dart';
import 'package:instagram_app/provider/usersProvider.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

class addPost extends StatefulWidget {
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  bool Isloading = false;
  Uint8List? imgPath;
  String? imgName;
  final captionController = TextEditingController();

  uploadImage2Screan(ImageSource imageSource) async {
    Navigator.pop(context);
    final PickedImg =
        await ImagePicker().pickImage(source: imageSource); // take a photo
    try {
      if (PickedImg != null) {
        imgPath = await PickedImg.readAsBytes(); // to work in web
        setState(() {
          // imgPath = File(PickedImg.path); // save photo link in variable
          imgName = basename(PickedImg.path);
          int random = Random().nextInt(8);
          imgName = "$random$imgName";
        });
      } else {
        print("No Image Selected");
      }
    } catch (e) {
      print("Error >> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
//                                     <classproviderName>
    final ALLuserDATAS = Provider.of<userProvider>(context).getUser;

    return imgPath != null
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    imgPath = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              backgroundColor: seconderyColor,
              title: const Text("post Details"),
            ),
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(imgPath!),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              Isloading = true;
                            });

                            fireStoreMethods().oploadPost(
                                context: context,
                                description: captionController.text,
                                username: ALLuserDATAS?.userName,
                                profileImg: ALLuserDATAS?.userImg,
                                imgPath: imgPath,
                                imgName: imgName,
                                postsImgs: 'postsImgs');
                            setState(() {
                              Isloading = false;
                              imgPath = null;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text(
                            "Add post",
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(12)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 10, 124, 78)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ],
                    ),
                  ),
                  Isloading
                      ? const LinearProgressIndicator()
                      : const Divider(
                          color: Color.fromARGB(255, 78, 78, 78),
                          thickness: 1,
                        ),
                  const SizedBox(
                    height: 35,
                  ),
                  TextField(
                    controller: captionController,
                    decoration: const InputDecoration(
                        hintText: "Write a caption",
                        fillColor: Color.fromARGB(255, 205, 204, 204)),
                    maxLines: 8,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: seconderyColor,
              title: const Text("add post"),
            ),
            body: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                uploadImage2Screan(ImageSource.camera);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.camera_alt),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("Choose from Camera")
                                ],
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                uploadImage2Screan(ImageSource.gallery);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.photo_library_outlined),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("Choose from gallary")
                                ],
                              ),
                            ),
                          ],
                        );
                      });
              
              
              
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "Add post",
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(12)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 10, 124, 78)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
              ),
            ),
          );
  }
}
