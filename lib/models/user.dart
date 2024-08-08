import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProfile {
  //uid
  //name
  //emsil
  //username
  //bio//pic(later)

  final String uid;
  final String name;
  final String email;
  final String username;
  String bio;

  UserProfile(
      {required this.uid,
      required this.name,
      required this.email,
      required this.username,
      required this.bio});

  //firestore doc to userpro

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
        uid: doc['uid'],
        name: doc['name'],
        email: doc['email'],
        username: doc['username'],
        bio: doc['bio']);
  }

  //userpro to map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio
    };
  }
}
