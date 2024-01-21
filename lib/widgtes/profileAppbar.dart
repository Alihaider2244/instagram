import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/Utils/Navigation.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:instagram_clone/screens/authScreens/login_screen.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getUser;
    return GestureDetector(
      // Handle tapping outside the bottom sheet
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  print('Logout');
                  bool success = await AuthMethods().LogOutUser();
                  if (success == true) {
                    Utils().showSnackbar(context, 'loged out');
                    NavigationSystem()
                        .navigationpushperm(context, LoginScreen());
                  }
                },
                child: const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
