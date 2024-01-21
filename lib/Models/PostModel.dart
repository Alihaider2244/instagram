import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? description;
  final String postid;
  final String uid;
  final String photoURL;
  final String username;
  final datePublished;
  final likes;
  final String DPpic;
  
  PostModel({
    required this.description,
    required this.postid,
    required this.uid,
    required this.photoURL,
    required this.username,
    required this.datePublished,
    required this.likes,
    required this.DPpic,
    
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'username': username,
        'uid': uid,
        'photoURL': photoURL,
        'postid': postid,
        'likes': likes,
        'datePublished': datePublished,
        'DPpic': DPpic,
      };

   static List<PostModel> fromQuerySnapshot(QuerySnapshot snap) {
    return snap.docs.map((doc) {
      var snapshot = doc.data() as Map<String, dynamic>;
      return PostModel(
        description: snapshot['description'],
        postid: snapshot['postid'],
        uid: snapshot['uid'],
        photoURL: snapshot['photoURL'],
        username: snapshot['username'],
        likes: snapshot['likes'],
        datePublished: snapshot['datePublished'],
        DPpic: snapshot['DPpic'],
      );
    }).toList();
  }
}
