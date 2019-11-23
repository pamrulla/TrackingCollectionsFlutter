import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/logout_widget.dart';

class CustomerViewScreen extends StatefulWidget {
  @override
  _CustomerViewScreenState createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen> {
  Widget getBasicDetails() {
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
            child: Image.asset(
              'images/profile.jpg',
              width: 100,
              height: 100,
            ),
          ),
          Divider(),
          TableRow('ID', '001'),
          Divider(),
          TableRow('Name', 'Ravi'),
          Divider(),
          TableRow('Duration', 'Monthly'),
          Divider(),
          TableRow('Amount', '20000.00'),
          Divider(),
          TableRow('InterestRate', '3.50'),
          Divider(),
          TableRow('Months', '10'),
          Divider(),
          TableRow('Phone', '1234567890'),
          Divider(),
          TableRow('Permanent Address', 'Kakinada'),
          Divider(),
          TableRow('Temporary Address', 'Rajahmundry'),
          Divider(),
          TableRow('Documents Submitted', ''),
          Divider(),
          TableRow('Adhar', 'Link'),
          Divider(),
          TableRow('Pan Crd', 'Link'),
          Divider(),
        ],
      ),
    );
  }

  Widget getSingleSecurityDetails() {
    return Column(
      children: <Widget>[
        Center(
          child: Image.asset(
            'images/profile.jpg',
            width: 100,
            height: 100,
          ),
        ),
        Divider(),
        TableRow('Name', 'Ravi'),
        Divider(),
        TableRow('Phone', '1234567890'),
        Divider(),
        TableRow('Permanent Address', 'Kakinada'),
        Divider(),
        TableRow('Temporary Address', 'Rajahmundry'),
        Divider(),
        TableRow('Documents Submitted', ''),
        Divider(),
        TableRow('Adhar', 'Link'),
        Divider(),
        TableRow('Pan Crd', 'Link'),
        Divider(),
      ],
    );
  }

  Widget getSecurityDetails() {
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
          getSingleSecurityDetails(),
          getSingleSecurityDetails(),
        ],
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
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
        body: TabBarView(
          children: [
            Container(child: getBasicDetails()),
            Container(child: getPaymentDetails()),
            Container(child: getPenaltyDetails()),
            Container(child: getSecurityDetails()),
          ],
        ),
      ),
    );
  }
}

class TableValue extends StatelessWidget {
  final String text;
  final bool isAmount;
  const TableValue({@required this.text, this.isAmount = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
      ),
      textAlign: isAmount ? TextAlign.right : TextAlign.left,
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
  TableRow(this.header, this.value, {this.isAmount = false});

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
                ))
              : Container(),
        ],
      ),
    );
  }
}
