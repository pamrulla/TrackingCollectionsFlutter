import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/customer_view_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/viewmodels/CustomerList.dart';

class CustomersListScreen extends StatefulWidget {
  final DurationEnum currentDurationType;
  final String currentCity;
  CustomersListScreen(
      {@required this.currentDurationType, @required this.currentCity});

  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  List<CustomersList> agents = [];
  bool sort = false;
  @override
  void initState() {
    super.initState();
  }

  void onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        agents.sort((a, b) => a.name.compareTo(b.name));
      } else {
        agents.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }

  List<Widget> getAppBarActionsList() {
    List<Widget> items = [];
    if (Navigator.canPop(context)) {
      items.add(GotoHome());
    }
    items.add(Logout());
    return items;
  }

  @override
  Widget build(BuildContext context) {
    String subTitle =
        durations[DurationEnum.values.indexOf(widget.currentDurationType)];
    subTitle += ":";
    subTitle +=
        cities.singleWhere((elem) => elem.id == widget.currentCity).name;

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
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
      body: FutureBuilder(
          future: DBManager.instance
              .getCustomerList(widget.currentDurationType, widget.currentCity),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              agents = snapshot.data;
              if (agents.length == 0) {
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
                                ],
                                rows: agents
                                    .map(
                                      (agent) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(agent.name),
                                            onTap: () {
                                              viewCustomer(agent.id);
                                            },
                                          ),
                                          DataCell(
                                            Text(agent.amount.toString()),
                                            onTap: () {
                                              viewCustomer(agent.id);
                                            },
                                          ),
                                          DataCell(
                                            Text(agent.interestRate.toString()),
                                            onTap: () {
                                              viewCustomer(agent.id);
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
