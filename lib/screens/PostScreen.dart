import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/Utils/Navigation.dart';
import 'package:instagram_clone/screens/commentScreen.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/widgtes/LikeAnimation.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
import 'package:instagram_clone/Models/userModel.dart' as model;
import 'package:instagram_clone/resources/firestoreMethods.dart';

class PostScreen extends StatefulWidget {
  final snap;

  PostScreen({
    super.key,
    this.snap,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isAnimating = false;
  bool likeebool = false;
  bool value = false;

  model.UserModel? user;
  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUser;
  }

  Widget getCommentCount() {
    return Container(
      padding: EdgeInsets.zero,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.snap['postid'])
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading comments...');
          } else if (snapshot.hasError) {
            return Text('Error loading comments');
          } else {
            return Text(
              'view all ${snapshot.data!.docs.length} comments',
              style: TextStyle(color: secondaryColor),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.commentsSnap);
    UserModel user = Provider.of<UserProvider>(context).getUser;
    List myarr = [];
    myarr = widget.snap['likes'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['DPpic']),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Text(
                    widget.snap['username'],
                    style: TextStyle(color: primaryColor, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: ['Delete']
                                      .map((e) => Container(
                                            color: secondaryColor,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 10),
                                            child: TextButton(
                                              child: Text(e),
                                              onPressed: () async {
                                                bool valuee =
                                                    await AuthMethods()
                                                        .DeletePost(
                                                            user.uid,
                                                            widget.snap[
                                                                'postid']);
                                                if (valuee) {
                                                  Utils().showSnackbar(
                                                      context, 'deleted');
                                                } else {
                                                  Utils().showSnackbar(
                                                      context, 'erro');
                                                }
                                              },
                                            ),
                                          ))
                                      .toList(),
                                );
                              });
                        },
                        icon: Icon(Icons.more_vert)),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              value = await FirestorMethods().likesFirebase(
                  user.uid, widget.snap['likes'], widget.snap['postid']);
              setState(() {
                _isAnimating = true;
                likeebool = value;
              });
            },
            child: Stack(
              children: [
                SizedBox(
                  child: Image.network(
                    widget.snap['photoURL'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _isAnimating ? 1 : 0,
                    child: LikeAnimation(
                      child: Icon(
                        Icons.favorite,
                        color: primaryColor,
                        size: 100,
                      ),
                      isAnimating: _isAnimating,
                      duration: Duration(milliseconds: 288),
                      onEnd: () {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          setState(() {
                            _isAnimating = false;
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: false,
                smallLikes: true,
                child: IconButton(
                  onPressed: () async {
                    bool likevalue = await FirestorMethods().likesFirebase(
                        user.uid, widget.snap['likes'], widget.snap['postid']);
                    setState(() {
                      likeebool = likevalue;
                      value = likevalue;
                    });
                  },
                  icon: myarr.contains(widget.snap['uid'])
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_outline),
                ),
              ),
              IconButton(
                onPressed: () {
                  NavigationSystem().navigationpush(
                    context,
                    CommentScreen(
                      snap: widget.snap,
                    ),
                  );
                },
                icon: Icon(Icons.message),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_outline),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 40,
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: primaryColor),
                    children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              NavigationSystem().navigationpush(
                context,
                CommentScreen(
                  snap: widget.snap,
                ),
              );
            },
            child: getCommentCount(),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              DateFormat.yMMMd().format(
                (widget.snap['datePublished'] as Timestamp).toDate(),
              ),
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
