import 'package:flutter/material.dart';
import 'package:inkhaven/components/input_alert_box.dart';
import 'package:inkhaven/components/my_bio_box.dart';
import 'package:inkhaven/components/my_post_tile.dart';
import 'package:inkhaven/helper/navigation_pages.dart';
import 'package:inkhaven/models/user.dart';
import 'package:inkhaven/services/database_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  final bioTextController = TextEditingController();
  late final DatabaseProvider databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);
    setState(() {
      _isLoading = false;
    });
  }

  void _showEditBioBox() {
    bioTextController.text = user?.bio ?? '';
    showDialog(
      context: context,
      builder: (context) => InputAlertBox(
        hintText: 'Edit Bio',
        onPressedText: 'Save',
        textController: bioTextController,
        onPressed: saveBio,
      ),
    );
  }

  Future<void> saveBio() async {
    setState(() {
      _isLoading = true;
    });
    await databaseProvider.updateBio(bioTextController.text);
    user?.bio = bioTextController.text; // Update the local user object
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          _isLoading || user == null ? '' : user!.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          // Username
          Center(
            child: Text(
              _isLoading || user == null ? '' : '@${user!.username}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 25),

          // Profile icon
          Center(
            child: Container(
              padding: EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          SizedBox(height: 25),

          // Edit bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bio',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(Icons.settings,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          MyBioBox(text: _isLoading || user == null ? '..' : user!.bio),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25),
            child: Text(
              "Posts",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),

          // List of posts from user
          allUserPosts.isEmpty
              ? Center(child: Text("No posts yet.."))
              : ListView.builder(
                  itemCount:
                      allUserPosts.length, // Ensure itemCount is specified
                  itemBuilder: (context, index) {
                    final post = allUserPosts[index];
                    return MyPostTile(
                      post: post,
                      onUserTap: () {},
                      onPostTap: () => goPostPage(context, post),
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
        ],
      ),
    );
  }
}
