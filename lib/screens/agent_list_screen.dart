import 'package:flutter/material.dart';
import 'package:tracking_collections/components/agents_list_bottom_sheet.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/screens/customers_list_screen.dart';
import 'package:tracking_collections/utils/constants.dart';

class AgentList {
  String name;
  String number;
  String city;
  AgentList({this.name, this.number, this.city});

  static List<AgentList> getAgents() {
    return <AgentList>[
      AgentList(name: "Ravi", number: "231545", city: "Kakinada"),
      AgentList(name: "Raghu", number: "552231545", city: "Rajahmundry"),
      AgentList(name: "Reddy", number: "23147545", city: "Gannavaram"),
      AgentList(name: "Anil", number: "231545454", city: "Rajahmundry"),
      AgentList(name: "Khan", number: "23154745", city: "Kakinada"),
      AgentList(name: "Nagendra", number: "23961545", city: "Kakinada"),
    ];
  }
}

class AgentListScreen extends StatefulWidget {
  final DurationEnum currentDurationType;
  AgentListScreen({this.currentDurationType});

  @override
  _AgentListScreenState createState() => _AgentListScreenState();
}

class _AgentListScreenState extends State<AgentListScreen> {
  List<AgentList> agents = [];
  bool sort = false;
  @override
  void initState() {
    agents = AgentList.getAgents();
    super.initState();
  }

  void onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        agents.sort((a, b) => a.city.compareTo(b.city));
      } else {
        agents.sort((a, b) => b.city.compareTo(a.city));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String subTitle =
        durations[DurationEnum.values.indexOf(widget.currentDurationType)];
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
      body: Padding(
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
                                Text(agent.city),
                                onTap: () {
                                  viewDurationBottomSheet(agent);
                                },
                              ),
                              DataCell(
                                Text(agent.name),
                                onTap: () {
                                  viewDurationBottomSheet(agent);
                                },
                              ),
                              DataCell(
                                Text(agent.number),
                                onTap: () {
                                  viewDurationBottomSheet(agent);
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
      ),
    );
  }

  void viewDurationBottomSheet(AgentList agent) async {
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
            return CustomersListScreen(
              currentDurationType: widget.currentDurationType,
              currentCity: CityEnum.values[cities.indexOf(agent.city)],
            );
          },
        ),
      );
    } else if (action == agentListActionsEnum.NewCustomer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return AddCustomerScreen(
            currentMode: widget.currentDurationType,
          );
        }),
      );
    }
  }
}
