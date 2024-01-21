import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/screens/PostScreen.dart';
import 'package:instagram_clone/widgtes/commentCard.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/resources/firestoreMethods.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        title: Text('comments'),
        leading: BackButton(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kTextTabBarHeight,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.photoURL,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'comment as ${user.username}',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              TextButton(
                onPressed: () async {
                  bool value = await FirestorMethods().CommentToFirebase(
                    user.photoURL,
                    user.username,
                    controller.text,
                    widget.snap['postid'],
                    user.uid,
                  );

                  if (value == true) {
                    controller.clear();
                    Utils().showSnackbar(context, 'commented');
                  }
                },
                child: Text(
                  'Post',
                  style: TextStyle(color: blueColor),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.snap['postid'])
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: blueColor,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      snap: snapshots.data!.docs[index].data(),
                    );
                  },
                ),
              ),
              Text(
                'Total comments: ${snapshots.data!.docs.length}',
                style: TextStyle(color: primaryColor),
              ),
            ],
          );
        },
      ),
    );
  }
}
