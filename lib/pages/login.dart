// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously, camel_case_types

import 'package:flutter/material.dart';
import 'package:instagram_app/constants/textFields.dart';
import 'package:instagram_app/fire_base%20services/Auth.dart';
import 'package:instagram_app/pages/Regester.dart';
import 'package:instagram_app/pages/reset_password.dart';
import 'package:instagram_app/shared/colors.dart';
// import '../constants/textFields.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool isloading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Color.fromARGB(89, 187, 184, 184),

      body: Center(
        child: Container(
          margin: widthScreen > 600
              ? EdgeInsets.symmetric(horizontal: widthScreen / 4, vertical: 30)
              : null,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 55,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 43, color: Color.fromARGB(255, 196, 128, 94)),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  myTextField(
                      mycontroller: emailController,
                      onchange: (x) {},
                      validator: (value) {},
                      MyTextInputType: TextInputType.emailAddress,
                      isPassword: false,
                      hintTextt: "Enter your email : "),
                  SizedBox(
                    height: 55,
                  ),
                  myTextField(
                      mycontroller: passwordController,
                      onchange: (x) {},
                      validator: (value) {},
                      MyTextInputType: TextInputType.text,
                      isPassword: true,
                      hintTextt: "Enter your Password : "),
                  SizedBox(
                    height: 55,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      Auth().signin(
                        context: context,
                        emailController: emailController,
                        passwordController: passwordController,
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(seconderyColor),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(22, 12, 22, 12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    child: isloading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(fontSize: 25 , color: Colors.white),
                          ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => resetPassword()));
                      },
                      child: Text(
                        "Forget your password ?",
                        style: TextStyle(decoration: TextDecoration.underline),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Do not have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => signup()));
                          },
                          child: Text("  Sign up"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
