import 'package:flutter/material.dart';

class RemoveCircleButton extends StatelessWidget {
  final Function onPressed;
  final int index;
  RemoveCircleButton({@required this.index, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        onPressed(index);
      },
      icon: Icon(
        Icons.remove_circle,
        color: Colors.red,
        size: 40.0,
      ),
    );
  }
}
