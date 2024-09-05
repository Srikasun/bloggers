import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inkhaven/pages/settings_tile.dart';
import 'package:inkhaven/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        // Optional: Added padding for better layout
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            SettingsTile(
              action: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
              ),
              title: 'DARK MODE',
            ),
          ],
        ),
      ),
    );
  }
}
