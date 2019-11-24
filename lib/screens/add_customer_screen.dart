import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/bottom_navigation_bar.dart';
import 'package:tracking_collections/components/customer_basic_details_form.dart';
import 'package:tracking_collections/components/customer_document_form.dart';
import 'package:tracking_collections/components/customer_lending_info_form.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/utils/constants.dart';

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
  List<GlobalKey<FormState>> keys = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _subTitles.length; ++i) {
      keys.add(GlobalKey<FormState>());
    }
    _formWidgets.add(CustomerBasicDetailsForm(
      formKey: keys[0],
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerLendingInfoForm(
      formKey: keys[1],
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerDocumentForm(
      formKey: keys[2],
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerBasicDetailsForm(
      formKey: keys[3],
      onBack: onBack,
      onContinue: onContinue,
    ));
    _formWidgets.add(CustomerDocumentForm(
      formKey: keys[4],
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
          GotoHome(),
          Logout(),
        ],
      ),
      bottomNavigationBar: MyBottomnaviationBar(
        onTap: (value) => onBottomBarAction(value),
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
    if (!keys[_currentStep].currentState.validate()) {
      keys[_currentStep].currentState.save();
      _currentStep += 1;
      if (_formWidgets.length == _currentStep) {
        Navigator.pop(context);
      } else {
        setState(() {});
      }
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

  onBottomBarAction(value) {
    if (value == 0) {
      onBack();
    } else {
      onContinue();
    }
  }
}
