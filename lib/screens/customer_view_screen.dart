import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/models/customer.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/models/documents.dart';
import 'package:tracking_collections/screens/amount_recieve_bottom_screen.dart';
import 'package:tracking_collections/screens/image_viewer_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/viewmodels/CustomerBasicDetails.dart';

class CustomerViewScreen extends StatefulWidget {
  final String id;
  CustomerViewScreen(String _id) : id = _id;
  @override
  _CustomerViewScreenState createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final globalKey = GlobalKey<ScaffoldState>();
  Future<CustomerBasicDetails> _customerBasicDetailsFuture;
  Future<List<CustomerBasicDetails>> _securityBasicDetailsFuture;

  @override
  void initState() {
    print(widget.id);
    super.initState();
    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(_handleTabSelection);
    _customerBasicDetailsFuture =
        DBManager.instance.getCustomerBasicDetails(widget.id);
    _securityBasicDetailsFuture =
        DBManager.instance.getSecurityDetails(widget.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getBasicDetails(CustomerBasicDetails cbd, {bool isMain = true}) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.network(
              cbd.basicDetails.photo,
              width: 100,
              height: 100,
            ),
          ),
          Divider(),
          //TableRow('ID', '001'),
          //Divider(),
          TableRow('Name', cbd.basicDetails.name),
          Divider(),
          TableRow('Father Name', cbd.basicDetails.fatherName),
          Divider(),
          isMain
              ? TableRow('Duration', durations[cbd.lendingInfo.durationType])
              : Container(),
          isMain ? Divider() : Container(),
          isMain
              ? TableRow('Amount', cbd.lendingInfo.amount.toString())
              : Container(),
          isMain ? Divider() : Container(),
          isMain
              ? TableRow(
                  'InterestRate', cbd.lendingInfo.interestRate.toString())
              : Container(),
          isMain ? Divider() : Container(),
          isMain
              ? TableRow('Months', cbd.lendingInfo.months.toString())
              : Container(),
          isMain ? Divider() : Container(),
          Column(
            children: getPhoneNumbers(cbd.basicDetails.phone),
          ),
          TableRow('Permanent Address', cbd.basicDetails.permanentAddress),
          Divider(),
          TableRow('Temporary Address', cbd.basicDetails.temporaryAddress),
          Divider(),
          TableRow('Documents Submitted', ''),
          Divider(),
          Column(
            children: getDocumentsInfo(cbd.documents),
          ),
        ],
      ),
    );
  }

  List<Widget> getPhoneNumbers(List<String> phones) {
    List<Widget> items = [];
    for (int i = 0; i < phones.length; ++i) {
      items.add(TableRow(
        'Phone ' + (i + 1).toString(),
        phones[i],
      ));
      items.add(Divider());
    }
    return items;
  }

  List<Widget> getDocumentsInfo(Documents dc) {
    List<Widget> items = [];
    for (int i = 0; i < dc.documentNames.length; ++i) {
      items.add(TableRow(
        dc.documentNames[i],
        'View',
        isImageView: true,
        url: dc.documentProofs[i],
      ));
      items.add(Divider());
    }
    return items;
  }

  List<Widget> getSecurityDetailsList(
      List<CustomerBasicDetails> _securityBasicDetails) {
    List<Widget> items = [];
    for (int i = 0; i < _securityBasicDetails.length; ++i) {
      items.add(getBasicDetails(_securityBasicDetails[i], isMain: false));
    }
    return items;
  }

  Widget getSecurityDetails(List<CustomerBasicDetails> _securityBasicDetails) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getSecurityDetailsList(_securityBasicDetails),
      ),
    );
  }

  Widget getPaymentDetails() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TableRow(
            'Per Month',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          TableRow('Re-Payment History', ''),
          Divider(),
          Divider(),
          TableRow('Date', 'Amount'),
          Divider(),
          TableRow(
            '23:05:2019',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:06:2019',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:07:2019',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:08:2019',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:09:2019',
            '0',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:10:2019',
            '0',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:11:2019',
            '0',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:12:2019',
            '0',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:01:2020',
            '0',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:02:2020',
            '0',
            isAmount: true,
          ),
          Divider(),
          Divider(),
          TableRow(
            'Total Amount Repaid',
            '40000.00',
            isAmount: true,
          ),
          Divider(),
          Divider(),
        ],
      ),
    );
  }

  Widget getPenaltyDetails() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TableRow('Penalty Payment History', ''),
          Divider(),
          Divider(),
          TableRow('Date', 'Amount'),
          Divider(),
          TableRow(
            '23:06:2019',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          TableRow(
            '23:07:2019',
            '3000.00',
            isAmount: true,
          ),
          Divider(),
          Divider(),
          TableRow(
            'Total Penalty Paid',
            '6000.00',
            isAmount: true,
          ),
          Divider(),
          Divider(),
        ],
      ),
    );
  }

  Widget getFloatingActionButton() {
    if (_controller.index == 1 || _controller.index == 2) {
      return FloatingActionButton(
        onPressed: () {
          viewDurationBottomSheet(context);
          setState(() {});
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              icon: Icon(Icons.details),
              text: 'Basic Details',
            ),
            Tab(
              icon: Icon(Icons.payment),
              text: 'Payment Details',
            ),
            Tab(
              icon: Icon(Icons.confirmation_number),
              text: 'Penalty Details',
            ),
            Tab(
              icon: Icon(Icons.security),
              text: 'Security Details',
            ),
          ],
        ),
        title: AppbarTitileWithSubtitle(
          title: 'Customer View',
        ),
        actions: <Widget>[
          GotoHome(),
          Logout(),
        ],
      ),
      floatingActionButton: getFloatingActionButton(),
      body: TabBarView(
        controller: _controller,
        children: [
          FutureBuilder(
            future: _customerBasicDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                CustomerBasicDetails _customerBasicDetails = snapshot.data;
                return Container(child: getBasicDetails(_customerBasicDetails));
              } else {
                return LoadingPleaseWait();
              }
            },
          ),
          Container(child: getPaymentDetails()),
          Container(child: getPenaltyDetails()),
          FutureBuilder(
            future: _securityBasicDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CustomerBasicDetails> _securityBasicDetails =
                    snapshot.data;
                return Container(
                    child: getSecurityDetails(_securityBasicDetails));
              } else {
                return LoadingPleaseWait();
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void viewDurationBottomSheet(BuildContext context) async {
    Transaction trans = await showModalBottomSheet(
      context: context,
      builder: (context) {
        String title =
            (_controller.index == 1) ? 'Payment Form' : 'Penalty Form';
        return AmountRecieveBottomScreen(title);
      },
    );
    if (trans == null) {
      return;
    } else {
      String content = 'Transaction added on ' +
          trans.date +
          ' for amount Rs. ' +
          trans.amount.toString();
      final snackBar = SnackBar(
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      );
      globalKey.currentState.showSnackBar(snackBar);
    }
  }
}

class TableValue extends StatelessWidget {
  final String text;
  final bool isAmount;
  final bool isImageView;
  final String url;
  final String title;
  const TableValue(
      {@required this.text,
      this.isAmount = false,
      this.isImageView = false,
      this.url = '',
      this.title = ''});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isImageView) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ImageViewer(
              url,
              title: title,
            );
          }));
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: isImageView ? Colors.blueAccent : Colors.black,
        ),
        textAlign: isAmount ? TextAlign.right : TextAlign.left,
      ),
    );
  }
}

class TableHeading extends StatelessWidget {
  final String text;
  const TableHeading({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class TableRow extends StatelessWidget {
  final String header;
  final String value;
  final bool isAmount;
  final bool isImageView;
  final String url;
  TableRow(this.header, this.value,
      {this.isAmount = false, this.isImageView = false, this.url = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(child: TableHeading(text: header)),
          value.isNotEmpty
              ? Expanded(
                  child: TableValue(
                  text: value,
                  isAmount: isAmount,
                  isImageView: isImageView,
                  url: url,
                  title: header,
                ))
              : Container(),
        ],
      ),
    );
  }
}
