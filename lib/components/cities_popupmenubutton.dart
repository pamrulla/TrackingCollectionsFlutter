import 'package:flutter/material.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/utils/constants.dart';

class CitiesPopUpMenuButton extends StatefulWidget {
  final Function onSelected;
  CitiesPopUpMenuButton({this.onSelected});

  @override
  _CitiesPopUpMenuButtonState createState() => _CitiesPopUpMenuButtonState();
}

class _CitiesPopUpMenuButtonState extends State<CitiesPopUpMenuButton> {
  City _current = cities[0];
  List<PopupMenuEntry<City>> buildItems(BuildContext context) {
    List<PopupMenuEntry<City>> items = [];
    for (int i = 0; i < cities.length; ++i) {
      PopupMenuItem<City> item = PopupMenuItem<City>(
        value: cities[i],
        child: Text(cities[i].name),
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<City>(
      onSelected: (value) {
        setState(() {
          _current = value;
        });
        widget.onSelected(value);
      },
      itemBuilder: buildItems,
      child: Container(
        child: Row(
          children: <Widget>[
            Text(
              _current.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
