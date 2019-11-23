import 'package:flutter/material.dart';
import 'package:tracking_collections/utils/utils.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.power_settings_new,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Utils.logOut(context);
      },
    );
  }
}
