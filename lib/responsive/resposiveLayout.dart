import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/dimension.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';

class ResponsoveLayoutScreen extends StatefulWidget {
  final Widget WebScreenLaout;
  final Widget MobileScreenLaout;
  const ResponsoveLayoutScreen(
      {super.key,
      required this.WebScreenLaout,
      required this.MobileScreenLaout});

  @override
  State<ResponsoveLayoutScreen> createState() => _ResponsoveLayoutScreenState();
}

class _ResponsoveLayoutScreenState extends State<ResponsoveLayoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adddataUI();
  }

  void adddataUI() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.reefreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < webScreenSize) {
        return widget.MobileScreenLaout;
      } else {
        return widget.WebScreenLaout;
      }
    });
  }
}
