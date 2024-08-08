import 'package:bloggers/auth/auth_service.dart';
import 'package:bloggers/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _db = FirebaseFirestore.instance;

  Future<UserProfile?> userProfile(String uid) async {
    DocumentSnapshot doc = await _db.collection('Users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromDocument(doc);
    }
    return null;
  }

  // Update user bio
  Future<void> updateUserBioInFirebase(String bio) async {
    String uid = _auth.getCurrentUid();
    try {
      await _db.collection('Users').doc(uid).update({'bio': bio});
    } catch (e) {
      print('Error updating user bio: $e');
    }
  }

  Future<void> updateBio(String bio) => updateUserBioInFirebase(bio);
}
