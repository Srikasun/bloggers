import 'package:inkhaven/models/post.dart';
import 'package:inkhaven/pages/post_page.dart';
import 'package:inkhaven/pages/profile_page.dart';
import 'package:flutter/material.dart';

void goUserPage(BuildContext context, String uid) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)));
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => PostPage(post: post)));
}
