import 'package:flutter/material.dart';
import 'package:tracking_collections/components/agents_list_bottom_sheet.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/agent_add_line_screen.dart';
import 'package:tracking_collections/screens/customers_list_screen.dart';
import 'package:tracking_collections/screens/duration_bottom_screen.dart';
import 'package:tracking_collections/screens/new_line_screen.dart';
import 'package:tracking_collections/screens/remove_agent_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';
import 'package:tracking_collections/viewmodels/agent_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

enum headActionsEnum { Home, LogOut, Refresh }

class AgentListScreen extends StatefulWidget {
  AgentListScreen();

  @override
  _AgentListScreenState createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  Future<List<Agent>> agentsFuture;
  List<AgentViewModel> agents = [];
  bool sort = false;
  @override
  void initState() {
    agentsFuture = DBManager.instance.getAgentsList();
    super.initState();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        sortAsc();
      } else {
        sortDsc();
      }
    }
  }

  void refreshAgents() async {
    setState(() {
      agents.clear();
      agentsFuture = DBManager.instance.getAgentsList();
    });
  }

  List<Widget> getAppBarActionsList() {
    List<Widget> items = [];

    List<PopupMenuEntry<headActionsEnum>> entries = [];
    entries.add(PopupMenuItem<headActionsEnum>(
      value: headActionsEnum.Home,
      child: Text('Go to Home'),
    ));
    entries.add(PopupMenuItem<headActionsEnum>(
      value: headActionsEnum.Refresh,
      child: Text('Refresh'),
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
            case headActionsEnum.Refresh:
              refreshAgents();
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

  @override
  Widget build(BuildContext context) {
    String subTitle = currentAgent.name;
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Agents List',
          subTitle: subTitle,
        ),
        actions: getAppBarActionsList(),
      ),
      floatingActionButton: Tooltip(
        message: 'Add New Agent',
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewLineScreen();
            }));
            refreshAgents();
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
      body: FutureBuilder(
        future: agentsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (agents.length == 0) {
              agents.addAll(AgentViewModel.fromAgent(currentAgent));
            }
            if (agents.length <= currentAgent.city.length) {
              snapshot.data.forEach((a) {
                agents.addAll(AgentViewModel.fromAgent(a));
              });
              sortAsc();
            }
            if (agents.length == 0) {
              return Center(
                child: Text('No Agents assigned'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            sortAscending: sort,
                            sortColumnIndex: 0,
                            columns: [
                              DataColumn(
                                label: Text('Line'),
                                numeric: false,
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    sort = !sort;
                                  });
                                  onSortColumn(columnIndex, ascending);
                                },
                              ),
                              DataColumn(
                                label: Text('Name'),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text('Phone'),
                                numeric: true,
                              ),
                            ],
                            rows: agents
                                .map(
                                  (agent) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(cities
                                            .singleWhere(
                                                (elem) => elem.id == agent.city)
                                            .name),
                                        onTap: () {
                                          viewActionsBottomSheet(agent);
                                        },
                                      ),
                                      DataCell(
                                        Text(agent.id == currentAgent.id
                                            ? 'You'
                                            : agent.name),
                                        onTap: () {
                                          viewActionsBottomSheet(agent);
                                        },
                                      ),
                                      DataCell(
                                        Text(agent.number),
                                        onTap: () {
                                          viewActionsBottomSheet(agent);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                .toList()),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return LoadingPleaseWait();
          }
        },
      ),
    );
  }

  void viewActionsBottomSheet(AgentViewModel agent) async {
    agentListActionsEnum action = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return AgentSheetBottomScreen();
      },
    );
    if (action == null) {
      return;
    }
    if (action == agentListActionsEnum.CustomersList) {
      viewDurationBottomSheet(agent);
    } else if (action == agentListActionsEnum.CallAgent) {
      String url = 'tel:' + agent.number;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (action == agentListActionsEnum.AssignAgentToNewLine) {
      bool isUpdate = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return AgentAddLineScreen(agent: agent);
        }),
      );
      if (isUpdate != null && isUpdate) {
        refreshAgents();
      }
    } else if (action == agentListActionsEnum.RemoveAgent) {
      bool isUpdate = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return RemoveAgentScreen(agent: agent);
        }),
      );
      if (isUpdate != null && isUpdate) {
        refreshAgents();
      }
    }
  }

  void viewDurationBottomSheet(AgentViewModel agent) async {
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
            agent: agent,
            currentDuration: duration,
          );
        },
      ),
    );
  }

  void sortAsc() {
    agents.sort((a, b) => cities
        .singleWhere((elem) => elem.id == a.city)
        .name
        .compareTo(cities.singleWhere((elem) => elem.id == b.city).name));
  }

  void sortDsc() {
    agents.sort((a, b) => cities
        .singleWhere((elem) => elem.id == b.city)
        .name
        .compareTo(cities.singleWhere((elem) => elem.id == a.city).name));
  }
}
