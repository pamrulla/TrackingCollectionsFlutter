import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar(String text)
      : super(
          content: Text(
            text.isEmpty
                ? 'Some thing went wrong while adding Agent, please try again'
                : text,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.redAccent,
        );
}
