// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:inkhaven/auth/auth_service.dart';
import 'package:inkhaven/components/input_alert_box.dart';
import 'package:inkhaven/services/database_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:inkhaven/models/post.dart';
import 'package:provider/provider.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;
  const MyPostTile({
    Key? key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  }) : super(key: key);

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  final _commentController = TextEditingController();

  //on startup
  @override
  void initState() {
    super.initState();
    // Load comments
    _loadComment();
  }

  Future<void> _loadComment() async {
    print('Loading comments for post: ${widget.post.id}');
    await databaseProvider.loadComments(widget.post.id);
    print('Comments loaded: ${listeningProvider.getComments(widget.post.id)}');
  }

  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  //open comment box
  void _openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => InputAlertBox(
            hintText: "Type a comment",
            onPressed: () async {
              await _addComment();
            },
            onPressedText: "Post",
            textController: _commentController));
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    try {
      await databaseProvider.addComment(
          widget.post.id, _commentController.text.trim());
      _commentController.clear();
    } catch (e) {
      print(e);
    }
  }

  void _showOptions() {
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isOwnPost)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () async {
                    Navigator.pop(context);
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )
              else ...[
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text("Report"),
                  onTap: () {
                    Navigator.pop(context);
                    _reportPostConfirmationBox();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block),
                  title: Text("Block"),
                  onTap: () {
                    Navigator.pop(context);
                    _reportblockConfirmationBox();
                  },
                ),
              ],
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _reportPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Report message"),
              content: Text("Are you sure wnt to report this message"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                  onPressed: () async {
                    await databaseProvider.reportUser(
                        widget.post.id, widget.post.uid);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Message Reported")));
                  },
                  child: Text("Report"),
                )
              ],
            ));
  }

  void _reportblockConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Block User"),
              content: Text("Are you sure wnt to Block this user"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                  onPressed: () async {
                    await databaseProvider.blockUser(widget.post.uid);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("user blocked")));
                  },
                  child: Text("Block"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentuser(widget.post.id);
    int likeCount = listeningProvider.getLikeCount(widget.post.id);
    //listen to comment count
    int commentCount = listeningProvider.getComments(widget.post.id).length;

    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _showOptions,
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      Text(likeCount.toString())
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      commentCount.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
