import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget action;
  const SettingsTile({super.key, required this.action, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //colour
        color: Theme.of(context).colorScheme.secondary,

        //curved border

        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, top: 10),

      // list tile

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action,
        ],
      ),
    );
  }
}
