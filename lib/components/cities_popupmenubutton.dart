import 'package:flutter/material.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/utils/constants.dart';

class CitiesPopUpMenuButton extends StatefulWidget {
  final Function onSelected;
  final String city;
  CitiesPopUpMenuButton({this.onSelected, this.city});

  @override
  _CitiesPopUpMenuButtonState createState() => _CitiesPopUpMenuButtonState();
}

class _CitiesPopUpMenuButtonState extends State<CitiesPopUpMenuButton> {
  City _current = cities[0];
  String _previousCity = '';
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
  void initState() {
    super.initState();
    _previousCity = widget.city;
    if (widget.city.isNotEmpty) {
      _current = cities.singleWhere((elem) => elem.id == widget.city);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.city.isNotEmpty && _previousCity != widget.city) {
      _current = cities.singleWhere((elem) => elem.id == widget.city);
      widget.onSelected(_current);
      _previousCity = widget.city;
    }
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
