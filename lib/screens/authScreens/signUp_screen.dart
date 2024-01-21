import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/Pickimage.dart';
import 'package:instagram_clone/Utils/Navigation.dart';
import 'package:instagram_clone/screens/HomePage.dart';
import 'package:instagram_clone/widgtes/Input_field.dart';
import 'package:instagram_clone/widgtes/buttonwidget.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:instagram_clone/widgtes/textButtonWidget.dart';
import 'package:instagram_clone/responsive/resposiveLayout.dart';
import 'package:instagram_clone/responsive/webScreenlayout.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/screens/authScreens/login_screen.dart';
// ignore_for_file: use_build_context_synchronously

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final bioController = TextEditingController();

  final usernameController = TextEditingController();
  Uint8List? _image;
  String? loading = 'loading...';
  bool load = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpcalled() async {
    setState(() {
      load = true;
    });

    String valuee = await AuthMethods().SignUpUser(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        bio: bioController.text,
        filee: _image!,
        context: context);
    if (valuee == 'success') {
      loading = 'success';
      setState(() {});
      NavigationSystem().navigationpushperm(
          context,
          const ResponsoveLayoutScreen(
              WebScreenLaout: WebScreenLaout(),
              MobileScreenLaout: MobileScreenLaout()));
      Utils().showSnackbar(context, 'Success');
    } else {
      Utils().showSnackbar(context, valuee);
      load = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TextButtonWidget(
        text: "Already have an account?",
        buttontext: "Login",
        onPress: () {
          NavigationSystem().navigationpush(context, LoginScreen());
        },
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _image != null
                      ? CircleAvatar(
                          radius: 40, backgroundImage: MemoryImage(_image!))
                      : const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0e-9L-OuQW5Dqfbaqlpl84ptS0VWZbY1K_A&usqp=CAU'),
                        ),
                ),
                Positioned(
                    bottom: 1,
                    right: 1,
                    child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(Icons.camera_alt_outlined)))
              ]),
              const SizedBox(
                height: 20,
              ),
              InputFieldWidget(
                controller: usernameController,
                Obsecuretext: false,
                username: 'enter your username',
              ),
              const SizedBox(
                height: 10,
              ),
              InputFieldWidget(
                controller: emailController,
                Obsecuretext: false,
                username: 'enter your email',
              ),
              const SizedBox(
                height: 10,
              ),
              InputFieldWidget(
                controller: passwordController,
                Obsecuretext: false,
                username: 'enter your password',
              ),
              const SizedBox(
                height: 10,
              ),
              InputFieldWidget(
                controller: bioController,
                Obsecuretext: false,
                username: 'enter your bio',
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                onPress: () {
                  signUpcalled();
                  setState(() {});
                },
                text: load ? loading : 'Sign Up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
