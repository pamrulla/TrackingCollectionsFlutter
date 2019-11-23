import 'package:flutter/material.dart';

class GotoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.home,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
