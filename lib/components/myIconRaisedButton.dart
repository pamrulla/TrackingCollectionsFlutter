import 'package:flutter/material.dart';

class MyIconRaisedButton extends StatelessWidget {
  final String name;
  final Function onPressed;
  final Icon icon;
  MyIconRaisedButton(
      {@required this.name, @required this.onPressed, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        name,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );
  }
}
