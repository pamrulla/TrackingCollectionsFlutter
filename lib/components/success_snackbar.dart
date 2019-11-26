import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar(String text)
      : super(
          content: Text(
            text.isEmpty ? 'Successfully updated...' : text,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        );
}
