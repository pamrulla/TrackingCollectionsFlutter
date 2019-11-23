import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/components/myIconRaisedButton.dart';
import 'package:tracking_collections/screens/agent_list_screen.dart';
import 'package:tracking_collections/screens/duration_bottom_screen.dart';
import 'package:tracking_collections/screens/new_line_screen.dart';
import 'package:tracking_collections/utils/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(title: 'Tracking Collections'),
        actions: <Widget>[
          Logout(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Image.asset(
                  'images/logo.png',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                flex: 1,
                child: MyIconRaisedButton(
                  name: 'New Line',
                  icon: Icon(
                    Icons.add_circle,
                    size: 40.0,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return NewLineScreen();
                    }));
                  },
                ),
              ),
              Spacer(),
              Expanded(
                flex: 1,
                child: MyIconRaisedButton(
                  name: 'Existing Line',
                  icon: Icon(
                    Icons.layers,
                    size: 40.0,
                  ),
                  onPressed: viewDurationBottomSheet,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void viewDurationBottomSheet() async {
    DurationEnum duration = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return DurationBottomScreen();
      },
    );
    if (duration == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AgentListScreen(
          currentDurationType: duration,
        );
      }),
    );
  }
}
