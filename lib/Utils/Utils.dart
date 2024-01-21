import 'package:flutter/material.dart';

class Utils {
  showSnackbar(BuildContext context, String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
