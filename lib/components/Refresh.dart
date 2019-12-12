import 'package:flutter/material.dart';

class Refresh extends StatelessWidget {
  final Function onRefresh;
  Refresh({@required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.refresh,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: onRefresh,
    );
  }
}
