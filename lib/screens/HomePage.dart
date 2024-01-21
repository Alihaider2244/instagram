import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/Models/UserModel.dart' as model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
   
    return const Scaffold(
        // body: Center(child: Text(usermode.photoURL)),
        );
  }
}
