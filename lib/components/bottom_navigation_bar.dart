import 'package:flutter/material.dart';

class MyBottomnaviationBar extends StatelessWidget {
  final Function onTap;

  MyBottomnaviationBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) => onTap(value),
      currentIndex: 1,
      backgroundColor: Theme.of(context).primaryColorDark,
      fixedColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          title: Text('Cancel'),
          icon: Icon(Icons.cancel),
        ),
        BottomNavigationBarItem(
          title: Text('Submit'),
          icon: Icon(Icons.navigate_next),
        ),
      ],
    );
  }
}
