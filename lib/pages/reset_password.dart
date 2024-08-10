// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/constants/textFields.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:instagram_app/shared/snackBar.dart';

class resetPassword extends StatelessWidget {
  const resetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    bool isloading = false;
    final emailController = TextEditingController();

    resetPasswordd() async {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
      } on FirebaseAuthException catch (e) {
        ShowSnackBar(context, "error >> ${e.code}", 0xFFF4CC52);
      }

      // if (!mounted) return;
      Navigator.pop(context);
    }

    return Scaffold(
      //backgroundColor: Color.fromARGB(89, 187, 184, 184),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 80, 182, 84),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enter your Email and reset password",
                    style: TextStyle(fontSize: 18),
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
                    hintTextt: "enter your Email : ",
                    suffixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formkey.currentState!.validate()
                          ? resetPasswordd()
                          : ShowSnackBar(context, "in valid data", 0xFF49B369);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(BtnGreen),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(22, 12, 22, 12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    child: isloading
                        // ignore: dead_code
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Reset Password",
                            style: TextStyle(fontSize: 25),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
