import 'package:flutter/material.dart';
import 'package:instagram_clone/Models/PostModel.dart';

class PostProvider with ChangeNotifier {
  List<PostModel> _posts = [];

  List<PostModel> get getPosts => _posts;

  void setPosts(List<PostModel> posts) {
    _posts = posts;
    notifyListeners();
  }
}
