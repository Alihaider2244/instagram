import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';

class TextButtonWidget extends StatelessWidget {
  TextButtonWidget(
      {super.key, this.text, this.buttontext, required this.onPress});
  final text, buttontext;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(color: primaryColor),
          ),
          InkWell(
            onTap: () {
              onPress();
            },
            child: Container(
              child: Text(
                buttontext,
                style: TextStyle(color: primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
