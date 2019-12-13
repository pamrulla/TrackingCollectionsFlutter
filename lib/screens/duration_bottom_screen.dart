import 'package:flutter/material.dart';
import 'package:tracking_collections/utils/constants.dart';

class DurationBottomScreen extends StatelessWidget {
  List<Widget> getListTiles(BuildContext context) {
    List<Widget> listTiles = [];
    for (var i = 0; i < durations.length; ++i) {
      Widget item = GestureDetector(
        onTap: () {
          Navigator.pop(context, DurationEnum.values[i]);
        },
        child: ListTile(
          title: Text(
            durations[i],
            style: TextStyle(
              //fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          leading: Icon(
            icons[i],
            //size: 40.0,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      );
      listTiles.add(item);
      if (i != durations.length - 1) {
        listTiles.add(Divider());
      }
    }
    return listTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: getListTiles(context),
          ),
        ),
      ),
    );
  }
}
