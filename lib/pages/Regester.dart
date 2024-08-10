// ignore_for_file: camel_case_types, use_build_context_synchronously, non_constant_identifier_names, avoid_print, file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/constants/textFields.dart';
import 'package:instagram_app/fire_base%20services/auth.dart';
import 'package:instagram_app/pages/login.dart';
import 'package:instagram_app/provider/googleSignin.dart';
import 'package:instagram_app/screens.dart/Home.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/snackBar.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:path/path.dart' show basename;

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  Uint8List? imgPath;
  late String imgUrl;
  String? imgName;
  final _formkey = GlobalKey<FormState>();
  bool isvisibile = true;
  bool isloading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();

  bool ispass8char = false;
  bool hasno = false;
  bool hasupper = false;
  bool hasLower = false;
  bool hasSpecial = false;

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

  onPassChanged(String password) {
    // to check the changes in password and light green in page
    ispass8char = false;
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        ispass8char = true;
      }
      hasno = false;
      if (password.contains(RegExp(r'.[0-9]'))) {
        hasno = true;
      }

      hasupper = false;
      if (password.contains(RegExp(r'.[A-Z]'))) {
        hasupper = true;
      }

      hasLower = false;
      if (password.contains(RegExp(r'.[a-z]'))) {
        hasLower = true;
      }

      hasSpecial = false;
      if (password.contains(RegExp(r'.[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecial = true;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleAuth = Provider.of<GoogleSignInProvider>(context);
    final double widthScreen = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        //backgroundColor: Color.fromARGB(89, 187, 184, 184),
        body: Center(
          child: Container(
            margin: widthScreen > 600
                ? EdgeInsets.symmetric(
                    horizontal: widthScreen / 4, vertical: 30)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          imgPath == null
                              ? const CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      AssetImage("assets/img/user_avatar.png"),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage: MemoryImage(imgPath!),
                                ),
                          Positioned(
                              bottom: -15,
                              right: 5,
                              child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    uploadImage2Screan(
                                                        ImageSource.camera);
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    uploadImage2Screan(
                                                        ImageSource.gallery);
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .photo_library_outlined),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text(
                                                          "Choose from gallery")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.add_a_photo)))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 43,
                            color: Color.fromARGB(255, 196, 128, 94)),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      myTextField(
                        validator: (value) {
                          return value!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                              ? null
                              : " Enter a valid email ";
                        },
                        mycontroller: emailController,
                        MyTextInputType: TextInputType.emailAddress,
                        isPassword: false,
                        hintTextt: "Email : ",
                        suffixIcon: const Icon(Icons.email),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      myTextField(
                          validator: (value) {},
                          mycontroller: usernameController,
                          MyTextInputType: TextInputType.text,
                          isPassword: false,
                          suffixIcon: const Icon(Icons.person),
                          hintTextt: " user name : "),
                      const SizedBox(
                        height: 35,
                      ),
                      myTextField(
                          validator: (value) {},
                          mycontroller: phoneController,
                          MyTextInputType: TextInputType.number,
                          isPassword: false,
                          suffixIcon: const Icon(Icons.phone),
                          hintTextt: "phone no. : "),
                      const SizedBox(
                        height: 35,
                      ),
                      myTextField(
                          onchange: (password) {
                            setState(() {
                              onPassChanged(password!);
                            });
                          },
                          validator: (value) {
                            return value!.length < 8
                                ? " Enter at least 8 characters "
                                : null;
                          },
                          mycontroller: passwordController,
                          MyTextInputType: TextInputType.text,
                          isPassword: isvisibile ? true : false,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isvisibile = !isvisibile;
                                });
                              },
                              icon: isvisibile
                                  ? const Icon(Icons.lock)
                                  : const Icon(Icons.lock_open)),
                          hintTextt: "Password : "),
                      const SizedBox(
                        height: 35,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _formkey.currentState!.validate()
                              ? Auth().regester(
                                  context: context,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  usernameController: usernameController,
                                  phoneController: phoneController,
                                  imgPath: imgPath,
                                  imgName: imgName)
                              : ShowSnackBar(
                                  context, "in valid data", 0xFF49B369);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(seconderyColor),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(22, 12, 22, 12)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        child: isloading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign up",
                                style: TextStyle(fontSize: 25, color: Colors.white),
                              ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Do you have an account? "),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const login()));
                              },
                              child: const Text(" Login "))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await GoogleAuth.googlelogin();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.red, width: 1)),
                              child: SvgPicture.asset(
                                "assets/icons/google.svg",
//                                color: Colors.red,
                                height: 27,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
