import 'package:flutter/material.dart';

class myTextField extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final TextInputType MyTextInputType;
  final bool isPassword;
  final String hintTextt;
  final dynamic suffixIcon;
  final TextEditingController? mycontroller;
  final Function(String?)? validator;
  final Function(String?)? onchange;

  myTextField({
    Key? key,
    // ignore: non_constant_identifier_names
    required this.MyTextInputType,
    required this.isPassword,
    required this.hintTextt,
    required this.validator,
    this.onchange,
    this.suffixIcon,
    this.mycontroller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: (value) => onchange!(value),
        validator: (value) => validator!(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: mycontroller,
        keyboardType: MyTextInputType,
        obscureText: isPassword, //show words as dots ******
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            fillColor: Color.fromARGB(183, 190, 163, 233),
            hintText: hintTextt,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            // enabledBorder: OutlineInputBorder(borderSide: Divider.createBorderSide(context) ),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 241, 239, 239))),
            filled: true,
            contentPadding: EdgeInsets.all(15)));
  }
}
