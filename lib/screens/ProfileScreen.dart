import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/Models/PostModel.dart';
import 'package:instagram_clone/Models/PostModel.dart';
import 'package:instagram_clone/widgtes/buttonwidget.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/widgtes/profileAppbar.dart';
import 'package:instagram_clone/Provider/postProvider.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';

// import 'package:instagram_clone/Provider/postProvider.dart' ;

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({Key? key, this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  QuerySnapshot? Snapy;
  int postlength = 0;
  int foolowing = 0;
  int followers = 0;
  bool IsCurrentUser = false;

  @override
  void initState() {
    Getdata();
    super.initState();
  }

  Getdata() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      Snapy = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = snap.data()!;
      postlength = Snapy!.docs.length;
      // followers=snap['']

      setState(() {});
    } catch (e) {
      Utils().showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel model = Provider.of<UserProvider>(context).getUser;
    // String modalee = model.uid;
    if (userData['photoURL'] == null ||
        userData['username'] == null ||
        userData['followers'] == null) {
      return Center(
          child: SizedBox(height: 10, child: CircularProgressIndicator()));
    }
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              userData['username'],
              style: TextStyle(fontSize: 20),
            ),
          ),
          leadingWidth: 100,
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AppBarWidget();
                  },
                );
              },
              icon: const Icon(Icons.expand_more_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      userData['photoURL'],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        postlength.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'posts',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userData['followers'].length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'followers',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userData['following'].length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'following',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Expanded(
                    //   child:
                    // ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: widget.uid !=
                              FirebaseAuth.instance.currentUser!.uid
                          ? ButtonWidget(
                              onPress: () {
                                AuthMethods().Followers(model.uid, widget.uid);
                                setState(() {});
                              },
                              text: userData['followers'].contains(model.uid)
                                  ? 'Following'
                                  : 'Follow',
                              color: userData['followers'].contains(model.uid)
                                  ? secondaryColor
                                  : blueColor,
                              height: 35.0,
                            )
                          : ButtonWidget(
                              onPress: () {},
                              text: 'Edit profile',
                              color: secondaryColor,
                              height: 35.0,
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Posts')
                      .where('username', isEqualTo: userData['username'])
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No posts available for the current user.'),
                      );
                    }
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 40,
                          width: 50,
                          child: Image.network(
                            snapshot.data!.docs[index]['photoURL'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
