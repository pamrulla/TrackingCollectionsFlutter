import 'package:flutter/material.dart';

class FormSubHeadingText extends StatelessWidget {
  final String text;
  FormSubHeadingText({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.0,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
