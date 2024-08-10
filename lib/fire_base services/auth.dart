// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/models/Usermodel.dart';
import 'package:instagram_app/pages/login.dart';
import 'package:instagram_app/screens.dart/Home.dart';
import 'package:instagram_app/shared/snackBar.dart';

class Auth {
  void regester({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    TextEditingController? usernameController,
    TextEditingController? phoneController,
    Uint8List? imgPath,
    String? imgName,
  }) async {
    // ignore: unused_local_variable
    bool isloading = false;
    String imgUrl = '';

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (imgPath != null) {
        final storageRef = FirebaseStorage.instance.ref(
            "${FirebaseAuth.instance.currentUser!.uid}/profileImgs/$imgName ");
        // await storageRef.putFile(imgPath);
        //----------   we use down code instedof up in web  ----------/
        UploadTask uploadtask = storageRef.putData(imgPath);
        TaskSnapshot snap = await uploadtask;
        //-------------------/

        imgUrl = await snap.ref.getDownloadURL();

        ShowSnackBar(context, "Success", 0xFF49B369);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );

      CollectionReference users =
          FirebaseFirestore.instance.collection('instagramUsers');
      // use class to make a models in firebase for  a big projects and be more prof and more easy to work
      UserModel userDate = UserModel(
          email: emailController.text,
          password: passwordController.text,
          userName: usernameController?.text,
          phone: phoneController?.text,
          userImg: imgUrl,
          uid: credential.user?.uid,
          followers: [],
          following: [],
          Bio: "Hello world");

      await users
          .doc(credential.user?.uid)
          .set(userDate.convert2Map())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
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
    isloading = false;
  }

  signin({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      ShowSnackBar(context, "Succes", 0xFF49B369);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowSnackBar(context, "No user found for that email", 0xFFF4CC52);

        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ShowSnackBar(context, "wrong Password", 0xFFF4CC52);

        // print('Wrong password provided for that user.');
      } else {
        ShowSnackBar(context, "Error @@!", 0xFFF4CC52);
      }
    }
  }

  Future<UserModel> getUserDetails() async {
    // this go firebase and get datas
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('instagramUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // after get we convertSnap to Model as map
    return UserModel.convertSnap2Model(snap);
  }

}
