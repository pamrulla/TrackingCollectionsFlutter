import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/utils/constants.dart';

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
        title: AppbarTitileWithSubtitle(title: 'Existing Line'),
        actions: <Widget>[
          GotoHome(),
          Logout(),
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
