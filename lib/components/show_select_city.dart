import 'package:flutter/material.dart';
import 'package:tracking_collections/components/cities_popupmenubutton.dart';
import 'package:tracking_collections/components/form_sub_heading_text.dart';

class ShowSelectCity extends StatefulWidget {
  final Function onSelected;
  final String city;
  ShowSelectCity({@required this.onSelected, this.city = ''});

  @override
  _ShowSelectCityState createState() => _ShowSelectCityState();
}

class _ShowSelectCityState extends State<ShowSelectCity> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FormSubHeadingText(
            text: 'Select City:',
          ),
        ),
        Expanded(
          child: CitiesPopUpMenuButton(
            city: widget.city,
            onSelected: (value) {
              widget.onSelected(value);
            },
          ),
        )
      ],
    );
  }
}
