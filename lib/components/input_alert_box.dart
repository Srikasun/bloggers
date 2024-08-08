import 'package:flutter/material.dart';

class InputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;
  InputAlertBox(
      {Key? key,
      required this.hintText,
      required this.onPressed,
      required this.onPressedText,
      required this.textController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: textController,
        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: hintText,
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      actions: [
        //cancel
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            textController.clear();
          },
          child: Text('Cancel'),
        ),

        //save
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed!();
              textController.clear();
            },
            child: Text(onPressedText)),
      ],
    );
  }
}
