import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:inkhaven/models/comment.dart';
import 'package:inkhaven/models/post.dart';
import 'package:inkhaven/models/user.dart';

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

        print('Updated likes: $likedBy');
        print('Updated like count: $currentLikeCount');

        transaction.update(postDoc, {
          'likecount': currentLikeCount,
          'likedBy': likedBy,
        });
      });
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  //add comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      //create a commen
      Comment newComment = Comment(
          id: '',
          postId: postId,
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now());

      //convert to map
      Map<String, dynamic> newCommentMap = newComment.toMap();

      await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  //delete comment
  Future<void> deleteComment(String commentid) async {
    try {
      await _db.collection("Comments").doc(commentid).delete();
    } catch (e) {
      print(e);
    }
  }

  //fetch comment
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Comments")
          .where("postId", isEqualTo: postId)
          .get();
      List<Comment> comments =
          snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
      print('Fetched comments: $comments');
      return comments;
    } catch (e) {
      print('Error fetching comments for post $postId: $e');
      return [];
    }
  }

  //report
  Future<void> reportUserInFirebase(String postId, userId) async {
    final currentUserId = _auth.currentUser!.uid;

    //create areport
    final report = {
      'reportedBy': currentUserId,
      'messageId': postId,
      'messageOwnerId': userId,
      'timeStamp': FieldValue.serverTimestamp()
    };
    await _db.collection("Reports").add(report);
  }

  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;

    await _db
        .collection("Users")
        .doc(currentUserId)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
  }
}
