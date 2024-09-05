import 'package:flutter/material.dart';
import 'package:inkhaven/auth/auth_service.dart';
import 'package:inkhaven/models/comment.dart';
import 'package:inkhaven/models/post.dart';
import 'package:inkhaven/models/user.dart';
import 'package:inkhaven/services/database_services.dart';

class DatabaseProvider extends ChangeNotifier {
  final _auth = AuthService();
  final DatabaseServices _databaseServices = DatabaseServices();

  // Local list of posts
  List<Post> _allPosts = [];

  // Get posts
  List<Post> get allPosts => _allPosts;

  // Fetch user profile
  Future<UserProfile?> userProfile(String uid) async {
    return await _databaseServices.getUserFromFirebase(uid);
  }

  // Update user bio
  Future<void> updateBio(String bio) async {
    String uid = _auth.getCurrentUid();
    await _databaseServices.updateUserBioInFirebase(uid, bio);
    notifyListeners();
  }

  // Post a message
  Future<void> postMessage(String message) async {
    await _databaseServices.postMessageInFirebase(message);
    await loadAllPosts();
    notifyListeners();
  }

  // Load all posts
  Future<void> loadAllPosts() async {
    _allPosts = await _databaseServices.getAllPostFromFirebase();
    initializeLikeMap();
    notifyListeners();
  }

  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> deletePost(String postId) async {
    await _databaseServices.deletePostFromFirebase(postId);
    await loadAllPosts();
  }

  // Likes
  Map<String, int> _likedCounts = {};
  List<String> _likedPosts = [];

  bool isPostLikedByCurrentuser(String postId) => _likedPosts.contains(postId);

  int getLikeCount(String postId) => _likedCounts[postId] ?? 0;

  void initializeLikeMap() {
    final currentUserID = _auth.getCurrentUid();
    _likedCounts.clear();
    _likedPosts.clear();

    for (var post in _allPosts) {
      _likedCounts[post.id] = post.likecount;

      if (post.likedBy.contains(currentUserID)) {
        _likedPosts.add(post.id);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    final likedPostsOriginal = List<String>.from(_likedPosts);
    final likedCountsOriginal = Map<String, int>.from(_likedCounts);

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likedCounts[postId] = (_likedCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likedCounts[postId] = (_likedCounts[postId] ?? 0) + 1;
    }
    notifyListeners();

    try {
      await _databaseServices.toggleLikeFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostsOriginal;
      _likedCounts = likedCountsOriginal;
      notifyListeners();
    }
  }

  final Map<String, List<Comment>> _comments = {};

  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  Future<void> loadComments(String postId) async {
    final allComments = await _databaseServices.getCommentsFromFirebase(postId);
    _comments[postId] = allComments;
    notifyListeners();
  }

  //add a comment
  Future<void> addComment(String postId, message) async {
    await _databaseServices.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  //delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    await _databaseServices.deleteComment(commentId);
    await loadComments(postId);
  }

  Future<void> blockUser(String userId) async {
    await _databaseServices.blockUserInFirebase(userId);
    await loadAllPosts();
    notifyListeners();
  }

  Future<void> reportUser(String postId, userId) async {
    await _databaseServices.reportUserInFirebase(postId, userId);
  }
}
