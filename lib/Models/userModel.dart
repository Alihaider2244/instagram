import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? bio;
  final String email;
  final String uid;
  final String photoURL;
  final String username;

  final List? followers;
  final List? following;

  UserModel({
    required this.bio,
    required this.email,
    required this.uid,
    required this.photoURL,
    required this.username,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'photoURL': photoURL,
        'email': email,
        'followers': followers,
        'following': following,
        'bio': bio,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        bio: snapshot['bio'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        photoURL: snapshot['photoURL'],
        username: snapshot['username'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
