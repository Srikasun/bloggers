import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  final int likecount;
  final List<String> likedBy;

  Post(
      {required this.id,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp,
      required this.likecount,
      required this.likedBy});

  // Convert a Firestore document to a Post object
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      likecount: doc['likecount'],
      likedBy: List<String>.from(doc['likedBy']),
    );
  }

  // Convert a Post object to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likecount': likecount,
      'likedBy': likedBy,
    };
  }
}
