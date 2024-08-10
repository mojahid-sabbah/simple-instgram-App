// ignore_for_file: camel_case_types, use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/models/postModel.dart';
import 'package:instagram_app/shared/snackBar.dart';

class fireStoreMethods {
  void oploadPost({
    required BuildContext context,
    required String description,
    required String postsImgs,
    required String? username,
    required String? profileImg,
    required Uint8List? imgPath,
    required String? imgName,
  }) async {
    String imgUrl = '';

    try {
      if (imgPath != null) {
        final storageRef = FirebaseStorage.instance.ref(
            "${FirebaseAuth.instance.currentUser!.uid}/$postsImgs/$imgName ");
        // await storageRef.putFile(imgPath);
        //----------   we use down code instedof up in web  ----------/
        UploadTask uploadtask = storageRef.putData(imgPath);
        TaskSnapshot snap = await uploadtask;
        //-------------------/

        imgUrl = await snap.ref.getDownloadURL();
      }

      var id4 = const Uuid().v4();

      CollectionReference posts =
          FirebaseFirestore.instance.collection('postsCollection');
      // use class to make a models in firebase for  a big projects and be more prof and more easy to work
      postModel postDatas = postModel(
          profileImg: profileImg.toString(),
          username: username.toString(),
          description: description,
          imgPost: imgUrl,
          uid: FirebaseAuth.instance.currentUser!.uid,
          postId: id4,
          datePublished: DateTime.now(),
          likes: []);

      await posts
          .doc(id4)
          .set(postDatas.convert2Map())
          .then((value) =>
              ShowSnackBar(context, "post Added succesfully", 0xFF49B369))
          .catchError((error) => print("Failed to add post: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowSnackBar(context, "The password provided is too weak", 0xFFF4CC52);
      } else if (e.code == 'email-already-in-use') {
        ShowSnackBar(
            context, "The account already exists for that email", 0xFFF4CC52);
      } else if (e.code == 'invalid-email') {
        ShowSnackBar(context, "ERROR, Invalid Email @_@!", 0xFFF4CC52);
      } else {
        ShowSnackBar(context, "ERROR, please try again *_*!", 0xFFF4CC52);
      }
    } catch (e) {
      ShowSnackBar(context, e.toString(), 0xFFF4CC52);
    }

    // Set state after the try-catch block to ensure it's executed in all cases
  }







  addComments({
    required uID,
    required textComment,
    required postsID,
    required userName,
    required profilePic,
  }) async {
    String commentId = const Uuid().v4();
    await FirebaseFirestore.instance
        .collection("postsCollection")
        .doc(postsID)
        .collection("commentsCollection")
        .doc(commentId)
        .set({
      "profilePic": profilePic,
      "userName": userName,
      "textComment": textComment,
      "dataPuplish": DateTime.now(),
      "uID": uID,
      "commentID": commentId,
    });
  }

  toggleLikes({required likes, required allDataFromDB}) async {
    try {
      if (likes) {
        await FirebaseFirestore.instance
            .collection("postsCollection")
            .doc(allDataFromDB["postId"])
            .update({
          "likes":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("postsCollection")
            .doc(allDataFromDB["postId"])
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
