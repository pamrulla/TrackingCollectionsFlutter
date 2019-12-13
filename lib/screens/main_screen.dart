import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/screens/agent_list_screen.dart';
import 'package:tracking_collections/screens/customers_list_screen.dart';
import 'package:tracking_collections/screens/duration_bottom_screen.dart';
import 'package:tracking_collections/screens/new_line_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/viewmodels/agent_view_model.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> headWidgets() {
    List<Widget> items = [];
    /*items.add(Hero(
      tag: 'logo',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Image.asset(
          'images/logo.png',
          width: 100,
          height: 100,
        ),
      ),
    ));*/
    items.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: MyRaisedButton(
        name: 'New Line',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewLineScreen();
          }));
        },
      ),
    ));
    items.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: MyRaisedButton(
        name: 'Existing Line',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AgentListScreen();
            }),
          );
        },
      ),
    ));
    return items;
  }

  List<Widget> agentWidgets() {
    List<Widget> items = [];
    currentAgent.city.forEach((c) {
      City ct = cities.singleWhere((e) => e.id == c);
      items.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: MyRaisedButton(
          name: ct.name,
          onPressed: () {
            viewDurationBottomSheet(ct.id);
          },
        ),
      ));
    });
    return items;
  }

  void viewDurationBottomSheet(String city) async {
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
      MaterialPageRoute(
        builder: (context) {
          return CustomersListScreen(
            currentDuration: duration,
            agent: AgentViewModel.createFromAgent(currentAgent, city),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Tracking Collections',
          subTitle: currentAgent.name + ': Home',
        ),
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
            children: isHead ? headWidgets() : agentWidgets(),
          ),
        ),
      ),
    );
  }
}
