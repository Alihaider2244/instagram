import 'package:flutter/material.dart';
import 'package:instagram_clone/Utils/colors.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget(
      {super.key,
      this.text,
      required this.onPress,
      this.color = blueColor,
      this.width = double.infinity,
      this.height = 40.0});
  final text;
  final color;
  final Function onPress;
  final width;
  final height;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
        widget.onPress();
     
      },
      child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              color: widget.color, borderRadius: BorderRadius.circular(3)),
          child: Center(child: Text(widget.text))),
    );
  }
}
