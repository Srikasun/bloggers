// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloggers/components/my_comment_tile.dart';
import 'package:bloggers/components/my_post_tile.dart';
import 'package:bloggers/helper/navigation_pages.dart';
import 'package:bloggers/services/database_provider.dart';
import 'package:flutter/material.dart';

import 'package:bloggers/models/post.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  //provider

  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  @override
  Widget build(BuildContext context) {
    //listen to all comments
    final allComments = listeningProvider.getComments(widget.post.id);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          MyPostTile(
              post: widget.post,
              onUserTap: () => goUserPage(context, widget.post.uid),
              onPostTap: () {}),
          allComments.isEmpty
              ? Center(
                  child: Text("No comments yet.."),
                )
              : ListView.builder(
                  itemCount: allComments.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = allComments[index];
                    return MyCommentTile(
                        comment: comment,
                        onUserTap: () => goUserPage(context, comment.uid));
                  })
        ],
      ),
    );
  }
}
