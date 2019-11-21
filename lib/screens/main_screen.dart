import 'package:flutter/material.dart';
import 'package:tracking_collections/components/myIconRaisedButton.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/screens/duration_bottom_screen.dart';
import 'package:tracking_collections/screens/new_line_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Collections'),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Image.asset('images/icon.png'),
              ),
              SizedBox(
                width: 10.0,
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddCustomerScreen(
          currentMode: duration,
        );
      }),
    );
  }
}
