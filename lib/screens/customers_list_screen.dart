import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/screens/customer_view_screen.dart';
import 'package:tracking_collections/screens/duration_bottom_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';
import 'package:tracking_collections/viewmodels/CustomerList.dart';
import 'package:tracking_collections/viewmodels/agent_view_model.dart';

enum headActionsEnum { Home, LogOut, Refresh }

class CustomersListScreen extends StatefulWidget {
  final AgentViewModel agent;
  final DurationEnum currentDuration;
  CustomersListScreen({this.agent, this.currentDuration});

  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  List<CustomersList> customers = [];
  bool sort = false;
  @override
  void initState() {
    super.initState();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        customers.sort((a, b) => a.name.compareTo(b.name));
      } else {
        customers.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }

  void onRefresh() async {
    setState(() {});
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
      child: Text('Refresh List'),
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
            case headActionsEnum.Refresh:
              onRefresh();
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
    String subTitle = loggedinAgent.name;
    if (isHead) {
      subTitle = widget.agent.name;
    }
    subTitle += " : " + durations[widget.currentDuration.index];

    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Customers List',
          subTitle: subTitle,
        ),
        actions: getAppBarActionsList(),
      ),
      floatingActionButton: Tooltip(
        message: "Add New Customer",
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AddCustomerScreen(
                  currentMode: widget.currentDuration,
                  agent: widget.agent.id,
                );
              }),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
      body: FutureBuilder(
          future: DBManager.instance.getCustomerList(
              widget.agent.id, widget.currentDuration, widget.agent.city),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              customers = snapshot.data;
              if (customers.length == 0) {
                return Center(child: Text('No Customers'));
              } else {
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
                                    label: Text('Name'),
                                    numeric: false,
                                    onSort: (columnIndex, ascending) {
                                      setState(() {
                                        sort = !sort;
                                      });
                                      onSortColumn(columnIndex, ascending);
                                    },
                                  ),
                                  DataColumn(
                                    label: Text('Amount'),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text('Interest Rate'),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text('Duration Type'),
                                  ),
                                ],
                                rows: customers
                                    .map(
                                      (cust) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(cust.name),
                                            onTap: () {
                                              viewCustomer(cust.id);
                                            },
                                          ),
                                          DataCell(
                                            Text(cust.amount.toString()),
                                            onTap: () {
                                              viewCustomer(cust.id);
                                            },
                                          ),
                                          DataCell(
                                            Text(cust.interestRate.toString()),
                                            onTap: () {
                                              viewCustomer(cust.id);
                                            },
                                          ),
                                          DataCell(
                                            Text(durations[cust.durationType]),
                                            onTap: () {
                                              viewCustomer(cust.id);
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
              }
            } else {
              return LoadingPleaseWait();
            }
          }),
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
        return AddCustomerScreen(
          currentMode: duration,
        );
      }),
    );
  }

  void viewCustomer(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CustomerViewScreen(id);
        },
      ),
    );
  }
}
