import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget(
      {super.key, this.keyboardType, this.Obsecuretext, this.contentPadding, this.username,required this.controller });
  final keyboardType, Obsecuretext, contentPadding,username;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller:controller ,
      keyboardType: keyboardType,
      obscureText: Obsecuretext,
      decoration: InputDecoration(
          hintText: username,
          hintStyle: TextStyle(fontWeight: FontWeight.w500),
          border: inputborder,
          focusedBorder: inputborder,
          enabledBorder: inputborder,
          contentPadding: contentPadding,
          isDense: true,
          filled: true),
    );
  }
}
