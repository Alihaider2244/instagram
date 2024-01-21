import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel get getUser => _user ?? UserModel(
    bio: '',
    email: '',
    uid: '',
    photoURL: '',
    username: '',
    followers: [],
    following: [],
  );
  final AuthMethods _authMethods = AuthMethods();

  Future<void> reefreshUser() async {
    UserModel userModel = await _authMethods.GetuserDetails();
    _user = userModel;
    notifyListeners();
  }
}
