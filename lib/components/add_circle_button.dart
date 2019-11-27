import 'package:flutter/material.dart';

class AddCircleButton extends StatelessWidget {
  final Function onPressed;
  AddCircleButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.add_circle,
        color: Colors.green,
        size: 40.0,
      ),
    );
  }
}
