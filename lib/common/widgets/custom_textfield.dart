import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxlines;
  const CustomTextField({required this.hintText, required this.controller,  this.maxlines=1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
    );
  }
}
