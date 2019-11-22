import 'package:flutter/material.dart';

class AppbarTitileWithSubtitle extends StatelessWidget {
  final String title;
  final String subTitle;
  AppbarTitileWithSubtitle({@required this.title, this.subTitle = ''});

  Widget onlyTitle() {
    return Text(title);
  }

  Widget withSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return subTitle.isNotEmpty ? withSubtitle() : onlyTitle();
  }
}
