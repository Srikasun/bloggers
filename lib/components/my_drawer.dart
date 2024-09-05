import 'package:inkhaven/auth/auth_service.dart';
import 'package:inkhaven/components/my_drawer_tile.dart';
import 'package:inkhaven/pages/profile_page.dart';
import 'package:inkhaven/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final _auth = AuthService();

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.logout();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context,
          '/auth'); // Assuming you have a named route for the AuthGate or login page
    } catch (e) {
      // Handle logout error if needed
      print('Logout error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Icon(
              Icons.person,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // Home list tile
          MyDrawerTile(
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
            text: 'H O M E ',
          ),

          // Profile list tile
          MyDrawerTile(
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    uid: _auth.getCurrentUid(),
                  ),
                ),
              );
            },
            text: 'P R O F I L E',
          ),

          // Settings list tile
          MyDrawerTile(
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
            text: 'S E T T I N G S ',
          ),
          Spacer(),
          // Logout list tile
          MyDrawerTile(
            icon: Icons.logout,
            onTap: () async {
              await logout(context);
            },
            text: 'L O G O U T ',
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
