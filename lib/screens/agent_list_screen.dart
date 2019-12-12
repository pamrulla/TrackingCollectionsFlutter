import 'package:flutter/material.dart';
import 'package:tracking_collections/components/agents_list_bottom_sheet.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/screens/customers_list_screen.dart';
import 'package:tracking_collections/screens/duration_bottom_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:url_launcher/url_launcher.dart';

class AgentListScreen extends StatefulWidget {
  AgentListScreen();

  @override
  _AgentListScreenState createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  Future<List<Agent>> agentsFuture;
  List<Agent> agents;
  bool sort = false;
  @override
  void initState() {
    agentsFuture = DBManager.instance.getAgentsList();
    super.initState();
  }

  void onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        agents.sort((a, b) => cities
            .singleWhere((elem) => elem.id == a.city)
            .name
            .compareTo(cities.singleWhere((elem) => elem.id == b.city).name));
      } else {
        agents.sort((a, b) => cities
            .singleWhere((elem) => elem.id == b.city)
            .name
            .compareTo(cities.singleWhere((elem) => elem.id == a.city).name));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String subTitle = currentAgent.name;
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Existing Lines',
          subTitle: subTitle,
        ),
        actions: <Widget>[
          GotoHome(),
          Logout(),
        ],
      ),
      body: FutureBuilder(
        future: agentsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            agents = snapshot.data;
            if (agents[0].id != currentAgent.id) {
              agents.insert(0, currentAgent);
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
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          sortAscending: sort,
                          sortColumnIndex: 0,
                          columns: [
                            DataColumn(
                              label: Text('City'),
                              numeric: false,
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  sort = !sort;
                                });
                                onSortColum(columnIndex, ascending);
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

  void viewActionsBottomSheet(Agent agent) async {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CustomersListScreen(agent: agent);
          },
        ),
      );
    } else if (action == agentListActionsEnum.NewCustomer) {
      viewDurationBottomSheet(agent);
    } else if (action == agentListActionsEnum.CallAgent) {
      String url = 'tel:' + agent.number;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void viewDurationBottomSheet(Agent agent) async {
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
        return AddCustomerScreen(
          currentMode: duration,
          agent: agent.id,
        );
      }),
    );
  }
}
