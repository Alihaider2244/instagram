import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/Navigation.dart';
import 'package:instagram_clone/screens/HomePage.dart';
import 'package:instagram_clone/widgtes/Input_field.dart';
import 'package:instagram_clone/widgtes/buttonwidget.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:instagram_clone/widgtes/textButtonWidget.dart';
import 'package:instagram_clone/responsive/resposiveLayout.dart';
import 'package:instagram_clone/responsive/webScreenlayout.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/screens/authScreens/signUp_screen.dart';
// ignore_for_file: use_build_context_synchronously


class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  String loading = 'loading';
  bool load = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  LoginInuserMethod() async {
    setState(() {
      load = true;
    });
    String valuee = await AuthMethods().LoginUser(
        email: emailController.text, password: passwordController.text);
    if (valuee == 'success') {
      loading = 'success';
      setState(() {});
      NavigationSystem().navigationpushperm(
          context,
          const ResponsoveLayoutScreen(
              WebScreenLaout: WebScreenLaout(),
              MobileScreenLaout: MobileScreenLaout()));
      Utils().showSnackbar(context, 'Success');
    } else if (valuee == 'fill all fields') {
      Utils().showSnackbar(context, 'fill all fields');
    } else {
      Utils().showSnackbar(context, 'failed');
      // loading = 'Sign Up';
      load = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TextButtonWidget(
        text: "Don't you have an account?",
        buttontext: "Register",
        onPress: () {
          NavigationSystem().navigationpushperm(context, SignUpScreen());
        },
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              colorFilter:
                  const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 20,
            ),
            InputFieldWidget(
              controller: emailController,
              Obsecuretext: false,
              username: 'enter your email',
              contentPadding: const EdgeInsets.all(15),
            ),
            const SizedBox(
              height: 10,
            ),
            InputFieldWidget(
              controller: passwordController,
              Obsecuretext: false,
              username: 'password',
              contentPadding: const EdgeInsets.all(15),
            ),
            const SizedBox(
              height: 10,
            ),
            ButtonWidget(
              onPress: () {
                LoginInuserMethod();
              },
              text: load ? loading : 'Login',
            ),
          ],
        ),
      )),
    );
  }
}
