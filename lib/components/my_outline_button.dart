import 'package:flutter/material.dart';

class MyOutlineButton extends StatelessWidget {
  final String name;
  final Function onPressed;
  MyOutlineButton({@required this.name, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(20.0),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
        width: 2,
        style: BorderStyle.solid,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );
  }
}
