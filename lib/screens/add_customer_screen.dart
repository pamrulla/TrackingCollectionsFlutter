import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/bottom_navigation_bar.dart';
import 'package:tracking_collections/components/customer_basic_details_form.dart';
import 'package:tracking_collections/components/customer_document_form.dart';
import 'package:tracking_collections/components/customer_lending_info_form.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/models/basic_details.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class AddCustomerScreen extends StatefulWidget {
  final DurationEnum currentMode;
  AddCustomerScreen({this.currentMode});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
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

  BasicDetails _basicDetails = BasicDetails();

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
      data: _basicDetails,
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
      data: _basicDetails,
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
      key: globalKey,
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
      body: _isLoading
          ? LoadingPleaseWait()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: _formWidgets[_currentStep],
              ),
            ),
    );
  }

  void displayLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<bool> addBasicDetails() async {
    if (_basicDetails.photo == null || _basicDetails.photo.isEmpty) {
      Utils.showErrorSnackBar(globalKey,
          text: 'Photo of customer should not be empty...');
      return false;
    }
    String url =
        await DBManager.instance.uploadFileAndGetUrl(_basicDetails.photo);
    if (url.isEmpty) {
      return false;
    }
    Utils.deleteFile(_basicDetails.photo);
    _basicDetails.photo = url;
    return await DBManager.instance.addBasicDetails(_basicDetails);
  }

  void onContinue() async {
    if (keys[_currentStep].currentState.validate()) {
      keys[_currentStep].currentState.save();
      bool isSuccess = false;
      displayLoading(true);
      if (_currentStep == 0) {
        isSuccess = await addBasicDetails();
      }
      displayLoading(false);
      if (isSuccess == true) {
        Utils.showSuccessSnackBar(globalKey);
        _currentStep += 1;
        if (_formWidgets.length == _currentStep) {
          Navigator.pop(context);
        } else {
          setState(() {});
        }
      }
    }
  }

  void onBack() {
    //if (_currentStep == 0) {
    Navigator.pop(context);
    //} else {
    //  setState(() {
    //    _currentStep -= 1;
    //  });
    //}
  }

  onBottomBarAction(value) {
    if (value == 0) {
      onBack();
    } else {
      onContinue();
    }
  }
}
