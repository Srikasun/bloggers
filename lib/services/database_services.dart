import 'package:bloggers/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Save user info in Firebase
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;

    // Extract username from email
    String username = email.split('@')[0];

    // Create user profile
    UserProfile user = UserProfile(
        uid: uid, name: name, email: email, username: username, bio: '');

    // Convert user profile to map to store in database
    final userMap = user.toMap();

    // Save user info in database
    await _db.collection('Users').doc(uid).set(userMap);
  }

  // Get user info from Firebase
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('Users').doc(uid).get();

      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
