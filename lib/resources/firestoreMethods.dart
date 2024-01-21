import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorMethods {
  final instace = FirebaseFirestore.instance;
  // like data manage
  Future<bool> likesFirebase(String uid, List likes, String Postid) async {
    try {
      if (likes.contains(uid)) {
        await instace.collection('Posts').doc(Postid).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        return false;
      } else {
        await instace.collection('Posts').doc(Postid).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        return true;
      }
    } catch (e) {
      print(e.toString());
      return true;
    }
  }

  // comment data manage
  Future<bool> CommentToFirebase(
      String dp, String name, String text, String postId, String uid) async {
    try {
      String commentID = Uuid().v1();
      if (text.isNotEmpty) {
        await instace
            .collection('Posts')
            .doc(postId)
            .collection('comments')
            .doc(commentID)
            .set({
          'dp': dp,
          'name': name,
          'date': DateTime.now(),
          'text': text,
          'uid': uid,
          'commentID': commentID,
          'like': [],
        });
        return true;
      } else {
        print('text is empty');
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Future<int> commentLength(String uid,String postID,) async {

  //       return snapshot.docs.length;
  // }
}
