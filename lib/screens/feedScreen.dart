import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/PostModel.dart';
import 'package:instagram_clone/screens/PostScreen.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/Models/userModel.dart' as model;

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    model.UserModel? user = Provider.of<UserProvider>(context).getUser;

    if (user == null || user.uid == null || user.uid.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated or UID is missing.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 130,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SvgPicture.asset(
            'assets/images/ic_instagram.svg',
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collectionGroup(
                'Posts') // Use collectionGroup to query across all users

            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No posts available for any user.',
                style: TextStyle(color: primaryColor),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  PostScreen(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
