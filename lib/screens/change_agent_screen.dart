import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/form_sub_heading_text.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';

enum headActionsEnum { Home, LogOut }

class ChangeAgentScreen extends StatefulWidget {
  final String customerId;
  final String city;
  final String currentAgent;
  ChangeAgentScreen({this.customerId, this.city, this.currentAgent});

  @override
  _ChangeAgentScreenState createState() => _ChangeAgentScreenState();
}

class _ChangeAgentScreenState extends State<ChangeAgentScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Future<List<Agent>> _agentsFuture;
  List<Agent> _agents = [];
  int _selectedAgentIndex = 0;
  bool _isProcessing = false;

  List<Widget> getAppBarActionsList() {
    List<Widget> items = [];

    List<PopupMenuEntry<headActionsEnum>> entries = [];
    entries.add(PopupMenuItem<headActionsEnum>(
      value: headActionsEnum.Home,
      child: Text('Go to Home'),
    ));
    entries.add(PopupMenuItem<headActionsEnum>(
      value: headActionsEnum.LogOut,
      child: Text('Logout'),
    ));

    items.add(
      PopupMenuButton(
        icon: Icon(Icons.menu),
        onSelected: (headActionsEnum result) async {
          switch (result) {
            case headActionsEnum.LogOut:
              Utils.logOut(context);
              break;
            case headActionsEnum.Home:
              Navigator.of(context).popUntil((route) => route.isFirst);
              break;
          }
        },
        itemBuilder: (BuildContext context) => entries,
      ),
    );

    return items;
  }

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _agentsFuture = DBManager.instance.getAgentsListForRemoveAgent(
        widget.currentAgent, widget.city,
        isChangeAgent: true);
  }

  List<Widget> buildWidgets() {
    List<Widget> items = [];
    items.add(FormSubHeadingText(
      text: 'Choose an agent to transfer:',
    ));
    _agents.asMap().forEach((i, a) {
      items.add(ListTile(
        title: Text(a.id == loggedinAgent.id ? 'You' : a.name),
        leading: Radio(
          value: i,
          groupValue: _selectedAgentIndex,
          onChanged: (int value) {
            setState(() {
              _selectedAgentIndex = value;
            });
          },
        ),
      ));
    });
    items.add(SizedBox(
      height: 30.0,
    ));
    items.add(MyRaisedButton(
      name: 'Transfer',
      onPressed: doProcess,
    ));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Transfer Customer',
        ),
        actions: getAppBarActionsList(),
      ),
      body: _isProcessing
          ? LoadingPleaseWait()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 30.0),
                child: FutureBuilder(
                    future: _agentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _agents = snapshot.data;
                        print(_agents.length);
                        if (_agents.length == 0) {
                          return Center(
                            child: Text('No Agents assigned to current line ' +
                                cities
                                    .singleWhere((c) => c.id == widget.city)
                                    .name),
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: buildWidgets(),
                          );
                        }
                      } else {
                        return LoadingPleaseWait();
                      }
                    }),
              ),
            ),
    );
  }

  void doProcess() async {
    setProcessing(true);
    bool isSuccess = await DBManager.instance
        .transferCustomer(widget.customerId, _agents[_selectedAgentIndex].id);
    setProcessing(false);
    if (isSuccess) {
      Navigator.pop(context, true);
    } else {
      Utils.showErrorSnackBar(globalKey,
          text: 'Transfering customer is failed, please try again...');
    }
  }
}
