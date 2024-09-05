import 'package:inkhaven/components/input_alert_box.dart';
import 'package:inkhaven/components/my_drawer.dart';
import 'package:inkhaven/components/my_post_tile.dart';
import 'package:inkhaven/helper/navigation_pages.dart';
import 'package:inkhaven/models/post.dart';
import 'package:inkhaven/services/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DatabaseProvider _databaseProvider;

  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    _databaseProvider.loadAllPosts();
  }

  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => InputAlertBox(
        hintText: "What's on your mind?",
        onPressed: () async {
          await postMessage(_messageController.text);
          _messageController.clear();
          Navigator.pop(context);
        },
        onPressedText: "Post",
        textController: _messageController,
      ),
    );
  }

  Future<void> postMessage(String message) async {
    await _databaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Text(
              'INKHAVEN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            centerTitle: true,
          ),
          drawer: MyDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: _openPostMessageBox,
            child: Icon(Icons.add),
          ),
          body: _buildPostList(provider.allPosts),
        );
      },
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? Center(child: Text("Nothing here.."))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
