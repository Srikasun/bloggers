import 'package:bloggers/auth/auth_service.dart';
import 'package:bloggers/components/input_alert_box.dart';
import 'package:bloggers/components/my_bio_box.dart';
import 'package:bloggers/models/user.dart';
import 'package:bloggers/services/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          _isLoading ? '' : user!.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            //username
            Center(
              child: Text(
                _isLoading ? '' : '@${user!.username}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),

            //profile
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
            SizedBox(
              height: 25,
            ),

            //edit pro
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'bio',
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

            MyBioBox(text: _isLoading ? '..' : user!.bio),

            //no_of_posts

            //bio

            //list of posts from user
          ],
        ),
      ),
    );
  }
}
