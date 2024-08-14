// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloggers/components/my_post_tile.dart';
import 'package:bloggers/helper/navigation_pages.dart';
import 'package:flutter/material.dart';

import 'package:bloggers/models/post.dart';

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
  @override
  Widget build(BuildContext context) {
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
              onPostTap: () {})
        ],
      ),
    );
  }
}
