import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloggers/models/post.dart';
import 'package:bloggers/models/user.dart';

class DatabaseServices {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    final userMap = user.toMap();
    await _db.collection('Users').doc(uid).set(userMap);
  }

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        return UserProfile.fromDocument(userDoc);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);
      if (user != null) {
        Post newpost = Post(
          id: '',
          uid: uid,
          name: user.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
          likecount: 0,
          likedBy: [],
        );

        Map<String, dynamic> newpostMap = newpost.toMap();
        DocumentReference docRef =
            await _db.collection("Posts").add(newpostMap);

        // Update the post ID after creation
        await docRef.update({'id': docRef.id});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> getAllPostFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> updateUserBioInFirebase(String uid, String bio) async {
    try {
      await _db.collection('Users').doc(uid).update({'bio': bio});
    } catch (e) {
      print('Error updating user bio: $e');
    }
  }

  Future<void> toggleLikeFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);
        int currentLikeCount = postSnapshot['likecount'];

        if (!likedBy.contains(uid)) {
          likedBy.add(uid);
          currentLikeCount++;
        } else {
          likedBy.remove(uid);
          currentLikeCount--;
        }

        transaction.update(postDoc, {
          'likecount': currentLikeCount,
          'likedBy': likedBy,
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
