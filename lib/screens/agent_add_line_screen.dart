import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/bottom_navigation_bar.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/add_new_city_bottom_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';
import 'package:tracking_collections/viewmodels/agent_view_model.dart';

class AgentAddLineScreen extends StatefulWidget {
  final AgentViewModel agent;
  AgentAddLineScreen({@required this.agent});

  @override
  _AgentAddLineScreenState createState() => _AgentAddLineScreenState();
}

class _AgentAddLineScreenState extends State<AgentAddLineScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  Future<Agent> _currentAgentFuture;
  Agent _currentAgent = Agent();
  Map<String, bool> checkboxesStates = {};

  @override
  void initState() {
    super.initState();
    _currentAgentFuture = DBManager.instance.getAgentInfo(widget.agent.id);
  }

  void refresh() {
    setState(() {
      _currentAgentFuture = DBManager.instance.getAgentInfo(widget.agent.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Agent to New Line',
          subTitle: widget.agent.name,
        ),
        actions: <Widget>[
          GotoHome(),
          Logout(),
        ],
      ),
      bottomNavigationBar: MyBottomnaviationBar(
        onTap: _onAddingLine,
      ),
      body: isLoading
          ? LoadingPleaseWait()
          : FutureBuilder(
              future: _currentAgentFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAgent = snapshot.data;
                  updateCheckboxesStates();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: SingleChildScrollView(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            MyRaisedButton(
                                              name: 'Add New Line Name',
                                              onPressed: doAddNewLine,
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Text(
                                              'OR',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Text(
                                              'Select From Existing Lines',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 2.0,
                                      )),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: getListOfCheckboxes(),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 2.0,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return LoadingPleaseWait();
                }
              },
            ),
    );
  }

  void displayLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> _onAddingLine(int value) async {
    if (value == 1) {
      displayLoading(true);
      checkboxesStates.forEach((key, value) {
        if (value) {
          _currentAgent.city.add(key);
        }
      });
      bool isSuccess = await DBManager.instance.updateAgent(_currentAgent);
      displayLoading(false);
      if (isSuccess) {
        Navigator.pop(context, true);
      } else {
        Utils.showErrorSnackBar(globalKey,
            text: "Error while updating agent, please try again...");
      }
    } else {
      Navigator.pop(context, false);
    }
  }

  void doAddNewLine() async {
    String ret = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return AddNewCityBottomScreen();
      },
    );
    if (ret != null && ret.isNotEmpty) {
      City c = cities.singleWhere((c) {
        return ret == c.id;
      }, orElse: () {
        return null;
      });
      if (c != null) {
        checkboxesStates[c.id] = true;
      }
      setState(() {});
    }
  }

  List<Widget> getListOfCheckboxes() {
    List<Widget> items = [];
    cities.forEach((c) {
      if (!_currentAgent.city.contains(c.id)) {
        items.add(CheckboxListTile(
          title: Text(c.name),
          value: checkboxesStates[c.id],
          onChanged: (bool value) {
            setState(() {
              checkboxesStates[c.id] = value;
            });
          },
        ));
      }
    });
    return items;
  }

  void updateCheckboxesStates() {
    if (checkboxesStates.length == 0) {
      cities.forEach((c) {
        if (!_currentAgent.city.contains(c.id)) {
          checkboxesStates[c.id] = false;
        }
      });
    }
  }
}
