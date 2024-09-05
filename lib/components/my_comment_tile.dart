// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:inkhaven/auth/auth_service.dart';

import 'package:inkhaven/models/comment.dart';
import 'package:inkhaven/services/database_provider.dart';
import 'package:inkhaven/services/database_services.dart';
import 'package:provider/provider.dart';

class MyCommentTile extends StatefulWidget {
  final Comment comment;
  final void Function()? onUserTap;
  const MyCommentTile({
    Key? key,
    required this.comment,
    required this.onUserTap,
  }) : super(key: key);

  @override
  State<MyCommentTile> createState() => _MyCommentTileState();
}

class _MyCommentTileState extends State<MyCommentTile> {
  final DatabaseServices _databaseServices = DatabaseServices();

  void _showOptions(
    BuildContext context,
  ) {
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = widget.comment.uid == currentUid;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isOwnComment)
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _databaseServices.deleteComment(widget.comment.id);
                  },
                )
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: widget.onUserTap,
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 10),
              Text(
                widget.comment.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Text(
                '@${widget.comment.username}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _showOptions(context),
                child: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          widget.comment.message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        SizedBox(height: 25),
      ]),
    );
  }
}
