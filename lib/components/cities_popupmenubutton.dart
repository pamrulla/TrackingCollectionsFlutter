import 'package:flutter/material.dart';
import 'package:tracking_collections/utils/constants.dart';

class CitiesPopUpMenuButton extends StatefulWidget {
  final Function onSelected;
  CitiesPopUpMenuButton({this.onSelected});

  @override
  _CitiesPopUpMenuButtonState createState() => _CitiesPopUpMenuButtonState();
}

class _CitiesPopUpMenuButtonState extends State<CitiesPopUpMenuButton> {
  CityEnum _current = CityEnum.Kakinada;
  List<PopupMenuEntry<CityEnum>> buildItems(BuildContext context) {
    List<PopupMenuEntry<CityEnum>> items = [];
    for (int i = 0; i < CityEnum.values.length; ++i) {
      PopupMenuItem<CityEnum> item = PopupMenuItem<CityEnum>(
        value: CityEnum.values[i],
        child: Text(cities[i]),
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CityEnum>(
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
              cities[CityEnum.values.indexOf(_current)],
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
