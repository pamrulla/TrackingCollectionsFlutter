import 'package:flutter/material.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class ExistingLineScreen extends StatefulWidget {
  final DurationEnum currentMode;
  ExistingLineScreen({@required this.currentMode});

  @override
  _ExistingLineScreenState createState() => _ExistingLineScreenState();
}

class _ExistingLineScreenState extends State<ExistingLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Line'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Utils.logOut(context);
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            durations[DurationEnum.values.indexOf(widget.currentMode)],
            style: TextStyle(
              fontSize: 50.0,
            ),
          ),
        ),
      ),
    );
  }
}
