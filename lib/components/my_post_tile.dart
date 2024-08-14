// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloggers/auth/auth_service.dart';
import 'package:bloggers/services/database_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bloggers/models/post.dart';
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
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
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
                //this post belongs to current user
                if (isOwnPost)
                  //delete message button
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete"),
                    onTap: () async {
                      Navigator.pop(context);
                      await databaseProvider.deletePost(widget.post.id);
                    },
                  )
//post not belongs to user
                else ...[
                  ListTile(
                    leading: Icon(Icons.flag),
                    title: Text("Report"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.block),
                    title: Text("Block"),
                    onTap: () {
                      Navigator.pop(context);
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
        });
  }

  @override
  Widget build(BuildContext context) {
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentuser(widget.post.id);
    int likeCount = listeningProvider.getLikeCount(widget.post.id);
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)),
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
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.post.name,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),

                  //username handle
                  Text(
                    '@${widget.post.username}',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  Spacer(),
                  //button delete
                  GestureDetector(
                      onTap: _showOptions,
                      child: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
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
                          )),
                Text(likeCount.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}
