import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  final String name;
  final Function onPressed;
  MyRaisedButton({@required this.name, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      padding: EdgeInsets.all(20.0),
      elevation: 2.0,
      child: Text(
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
