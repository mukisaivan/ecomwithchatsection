// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextFeild(
      {super.key,
      this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 78, 78, 78))),
          fillColor: const Color.fromARGB(255, 218, 217, 217),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
