import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/Utils/globalScreensVar.dart';
import 'package:instagram_clone/Models/userModel.dart' as model;


class WebScreenLaout extends StatefulWidget {
  const WebScreenLaout({super.key});

  @override
  State<WebScreenLaout> createState() => _WebScreenLaoutState();
}

class _WebScreenLaoutState extends State<WebScreenLaout> {
  int page = 0;
  int index = 0;
  // List MyScreens = globalScreensVar();
  @override
  Widget build(BuildContext context) {
    model.UserModel usermode = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        // child: MyScreens[2],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          showSelectedLabels: false,
          enableFeedback: false,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
              page = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: page == 0 ? primaryColor : secondaryColor,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: page == 1 ? primaryColor : secondaryColor,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: page == 2 ? primaryColor : secondaryColor,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: page == 3 ? primaryColor : secondaryColor,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: page == 4 ? primaryColor : secondaryColor,
                ),
                label: ''),
          ]),
    );
  }
}
