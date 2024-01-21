import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Provider/postProvider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/responsive/resposiveLayout.dart';
import 'package:instagram_clone/responsive/webScreenlayout.dart';
import 'package:instagram_clone/firebaseWebConnect/webOptions.dart';
import 'package:instagram_clone/responsive/mobileScreenLayout.dart';
import 'package:instagram_clone/screens/authScreens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: webOptions().apiKey,
          appId: webOptions().appId,
          messagingSenderId: webOptions().messagingSenderId,
          storageBucket: webOptions().storageBucket,
          projectId: webOptions().projectId));

  await FirebaseAppCheck.instance.activate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
            textTheme: GoogleFonts.robotoCondensedTextTheme()),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else if (snapshot.hasData) {
              return const ResponsoveLayoutScreen(
                WebScreenLaout: WebScreenLaout(),
                MobileScreenLaout: MobileScreenLaout(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('some error'),
              );
            } else {
              return LoginScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
