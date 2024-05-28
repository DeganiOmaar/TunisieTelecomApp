// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTfield extends StatefulWidget {
  final bool isPassword;
  final String text;
  final IconData icon;
  final String? Function(String?)? validator;
  TextEditingController myController = TextEditingController();
  CustomTfield(
      {super.key,
      required this.isPassword,
      required this.text,
      required this.icon,
      required this.myController,
      required this.validator});

  @override
  State<CustomTfield> createState() => _CustomTfieldState();
}

class _CustomTfieldState extends State<CustomTfield> {
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        setState(() {
          isFocused = true;
        });
      },
      validator: widget.validator,
      controller: widget.myController,
      obscureText: widget.isPassword,
      keyboardType: TextInputType.text,
      cursorColor: Colors.black87,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: const TextStyle(color: Colors.black87),
        hintText: isFocused ? '' : widget.text,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black87),
        ),
        suffixIcon: Icon(
          widget.icon,
          color: Colors.black38,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
