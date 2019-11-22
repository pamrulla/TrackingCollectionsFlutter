import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/customer_basic_details_form.dart';
import 'package:tracking_collections/components/customer_document_form.dart';
import 'package:tracking_collections/components/customer_lending_info_form.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class AddCustomerScreen extends StatefulWidget {
  final DurationEnum currentMode;
  AddCustomerScreen({this.currentMode});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  int _currentStep = 0;
  List<Widget> _formWidgets = [];
  final List<String> _subTitles = [
    "Add Basic Details",
    "Add Lending Info",
    "Documents",
    "Security: Basic Details",
    "Security: Documents"
  ];

  @override
  void initState() {
    super.initState();
    _formWidgets.add(CustomerBasicDetailsForm(
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerLendingInfoForm(
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerDocumentForm(
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerBasicDetailsForm(
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerDocumentForm(
      onBack: onBack,
      onContinue: onContinue,
    ));
  }

  @override
  Widget build(BuildContext context) {
    String currentSubTitle = _subTitles[_currentStep];
    int cs = _currentStep + 1;
    currentSubTitle +=
        " (" + cs.toString() + "/" + _formWidgets.length.toString() + ")";
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'Adding New Customer',
          subTitle: currentSubTitle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Utils.logOut(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: _formWidgets[_currentStep],
        ),
      ),
    );
  }

  void onContinue() {
    _currentStep += 1;
    if (_formWidgets.length == _currentStep) {
      Navigator.pop(context);
    } else {
      setState(() {});
    }
  }

  void onBack() {
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _currentStep -= 1;
      });
    }
  }
}
