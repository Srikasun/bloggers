import 'package:bloggers/auth/auth_service.dart';
import 'package:bloggers/components/my_drawer_tile.dart';
import 'package:bloggers/pages/profile_page.dart';
import 'package:bloggers/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final _auth = AuthService();

  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //logo
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

          //home list tile
          MyDrawerTile(
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
            text: 'H O M E ',
          ),

          //profile list tile
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
                    ));
              },
              text: ' P R O F I L E'),

          // search list tile

          //settings list tile
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
          //logout list tile
          MyDrawerTile(
            icon: Icons.logout,
            onTap: () {
              logout();
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
