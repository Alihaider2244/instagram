import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../Models/PostModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/Models/PostModel.dart' as model;
import 'package:instagram_clone/Models/userModel.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // static final FirebaseAuth correntuser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Follow and Following
  Future<void> Followers(
    String currentUser,
    String ToFollow,
  ) async {
    DocumentSnapshot user =
        await _firestore.collection('users').doc(currentUser).get();
    List following = user['following'];

    DocumentSnapshot userToFollow =
        await _firestore.collection('users').doc(ToFollow).get();
    List followersToFollow = userToFollow['followers'];

    if (following.contains(ToFollow)) {
      print('following');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .update({
        'following': FieldValue.arrayRemove([ToFollow])
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(ToFollow)
          .update({
        'followers': FieldValue.arrayRemove([currentUser])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .update({
        'following': FieldValue.arrayUnion([ToFollow])
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(ToFollow)
          .update({
        'followers': FieldValue.arrayUnion([currentUser])
      });
    }
  }

// get userdata
Future<model.UserModel> GetuserDetails() async {
  User? currentUser = _auth.currentUser;

  if (currentUser != null) {
    // Use a loop to wait for the document to be created
    for (int i = 0; i < 5; i++) {
      // You can adjust the number of iterations and delay based on your requirements
      await Future.delayed(const Duration(seconds: 1));

      DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

      if (snap.exists) {
        return model.UserModel.fromSnap(snap);
      }
    }

    // If the document is still not found after the loop, throw an exception
    throw Exception("User document not found");
  } else {
    // Handle the case where the current user is null
    throw Exception("Current user is null");
  }
}


  //getPostdata
  Future<List<PostModel>> GetPostData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      QuerySnapshot snap = await _firestore.collection('Posts')
          .get();

      return PostModel.fromQuerySnapshot(snap);
    } else {
      throw Exception("Current user is null");
    }
  }

//SignuP user
  Future<String> SignUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List filee,
    required BuildContext context,
  }) async {
    String res = 'Some error';
    try {
      UserCredential usercred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String photoURL = await StorageMethods().UploadImagetoStorage(
        childName: 'profilePhotos',
        file: filee,
        isPost: false,
      );

      model.UserModel user = model.UserModel(
        bio: bio,
        email: email,
        uid: usercred.user!.uid,
        photoURL: photoURL,
        username: username,
        followers: [],
        following: [],
      );

      await _firestore
          .collection('users')
          .doc(usercred.user!.uid)
          .set(user.toJson());

      res = 'success stored';
      print(res);
    } catch (e) {
      print('Error creating user: $e');

      res = 'Error: $e';
      Utils().showSnackbar(context, e.toString());
    }
    return res;
  }

//deleting post
  Future<bool> DeletePost(String uid, String postID) async {
    try {
      await _firestore.collection('Posts').doc(postID)
          .delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

//saving post
  Future<String> UploadPostToFirebase(
    String Caption,
    Uint8List file,
    String userid,
    String username,
    String dpPic,
  ) async {
    String res = 'some error';
    String postID = Uuid().v1();
    try {
      String PostImageUrl = await StorageMethods().UploadPostIMageToStorage(
          childName: 'PostImageUrl', file: file, postID: postID);
      // print(PostImageUrl);

      PostModel post = PostModel(
          datePublished: DateTime.now(),
          description: Caption,
          postid: postID,
          uid: userid,
          photoURL: PostImageUrl,
          username: username,
          likes: [],
          DPpic: dpPic);

      await _firestore.collection('Posts').doc(postID).set(post.toJson());
      return res = 'success';
    } catch (e) {
      print(e.toString());

      return e.toString();
    }
  }

  //Login user
  Future<String> LoginUser(
      {required String email, required String password}) async {
    if (email.isNotEmpty || password.isNotEmpty) {
      String res = 'some error';
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
        return res;
      } catch (e) {
        res = 'error';
        return e.toString();
      }
    } else {
      String res = 'please fill fileds';
      return res;
    }
  }

  Future<bool> LogOutUser() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
