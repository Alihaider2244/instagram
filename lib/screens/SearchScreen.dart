import 'package:flutter/material.dart';
import '../Provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/screens/ProfileScreen.dart';
import 'package:instagram_clone/Models/UserModel.dart' as model;
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  bool ishowUser = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;

    if (user == null || user.uid == null || user.uid.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated or UID is missing.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            onFieldSubmitted: (String_) {
              setState(() {
                ishowUser = true;
              });
            },
            style: TextStyle(color: primaryColor),
            controller: controller,
            decoration: InputDecoration(
                hintText: 'search...', border: InputBorder.none),
          ),
        ),
      ),
      body: ishowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: controller.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        String Userr =
                            (snapshot.data! as dynamic).docs[index]['uid'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(uid: Userr))));
                          },
                          child: ListTile(
                              title: Text((snapshot.data! as dynamic)
                                  .docs[index]['username']),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoURL']),
                              )),
                        );
                      });
                }
              })
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collectionGroup(
                      'Posts') // Use collectionGroup to query across all users

                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  itemBuilder: (context, index) {
                    return Image.network(
                        (snapshot.data! as dynamic).docs[index]['photoURL']);
                  },
                );
              },
            ),
    );
  }
}
