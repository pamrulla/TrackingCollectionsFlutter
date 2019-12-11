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
import 'package:tracking_collections/models/documents.dart';
import 'package:tracking_collections/models/lending_info.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';

class AddCustomerScreen extends StatefulWidget {
  final DurationEnum currentMode;
  final String currentCustomer;
  AddCustomerScreen({this.currentMode, this.currentCustomer = ''});

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
    "Security 1: Basic Details",
    "Security 1: Documents",
    ""
  ];
  List<GlobalKey<FormState>> keys = [];

  BasicDetails _basicDetails = BasicDetails();
  LendingInfo _lendingInfo = LendingInfo();
  Documents _documents = Documents();
  List<BasicDetails> _securities = [];
  List<Documents> _securitiesDocs = [];

  void initSettings() async {
    displayLoading(true);
    if (widget.currentCustomer.isEmpty) {
      newCustomerBasicSettings();
    } else {
      await editCustomerBasicSettings();
    }
    displayLoading(false);
  }

  bool isEditMode() {
    return widget.currentCustomer.isNotEmpty;
  }

  Future<void> editCustomerBasicSettings() async {
    _lendingInfo.city = cities[0].id;
    _securities.add(BasicDetails());
    _securitiesDocs.add(Documents());

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
      data: _lendingInfo,
    ));
    _formWidgets.add(CustomerDocumentForm(
      formKey: keys[2],
      onBack: onBack,
      onContinue: onContinue,
      data: _documents,
    ));
    _formWidgets.add(CustomerBasicDetailsForm(
      formKey: keys[3],
      onBack: onBack,
      onContinue: onContinue,
      data: _securities[0],
    ));
    _formWidgets.add(CustomerDocumentForm(
      formKey: keys[4],
      onBack: onBack,
      onContinue: onContinue,
      data: _securitiesDocs[0],
    ));
  }

  void newCustomerBasicSettings() {
    _lendingInfo.city = cities[0].id;
    _securities.add(BasicDetails());
    _securitiesDocs.add(Documents());

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
      data: _lendingInfo,
    ));
    _formWidgets.add(CustomerDocumentForm(
      formKey: keys[2],
      onBack: onBack,
      onContinue: onContinue,
      data: _documents,
    ));
    _formWidgets.add(CustomerBasicDetailsForm(
      formKey: keys[3],
      onBack: onBack,
      onContinue: onContinue,
      data: _securities[0],
    ));
    _formWidgets.add(CustomerDocumentForm(
      formKey: keys[4],
      onBack: onBack,
      onContinue: onContinue,
      data: _securitiesDocs[0],
    ));
  }

  @override
  void initState() {
    super.initState();
    initSettings();
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
          title: isEditMode() ? 'Update Customer' : 'Adding New Customer',
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

  Future<String> uploadAndGetUrl(String path) async {
    String url = await DBManager.instance.uploadFileAndGetUrl(path);
    if (url == null || url.isEmpty) {
      return '';
    }
    Utils.deleteFile(path);
    return url;
  }

  bool validateBasicDetails() {
    if (_basicDetails.photo == null || _basicDetails.photo.isEmpty) {
      Utils.showErrorSnackBar(globalKey,
          text: 'Photo of customer should not be empty...');
      return false;
    }
    return true;
  }

  bool validateLendingInfo() {
    _lendingInfo.durationType = DurationEnum.values.indexOf(widget.currentMode);
    _lendingInfo.agent = currentAgent.id;
    return true;
  }

  bool validateDocumentDetails() {
    if (_documents.documentProofs.length > 0 &&
        _documents.documentNames.length > 0 &&
        _documents.documentNames.length == _documents.documentProofs.length) {
      return true;
    }
    return false;
  }

  bool validateSecurityBasicDetails() {
    if (_securities[0].photo == null || _securities[0].photo.isEmpty) {
      Utils.showErrorSnackBar(globalKey,
          text: 'Photo of customer should not be empty...');
      return false;
    }
    return true;
  }

  bool validateSecurityDocumentDetails() {
    if (_securitiesDocs[0].documentProofs.length > 0 &&
        _securitiesDocs[0].documentNames.length > 0 &&
        _securitiesDocs[0].documentNames.length ==
            _securitiesDocs[0].documentProofs.length) {
      return true;
    }
    return false;
  }

  void onContinue() async {
    if (keys[_currentStep].currentState.validate()) {
      keys[_currentStep].currentState.save();
      bool isSuccess = false;
      displayLoading(true);
      if (_currentStep == 0) {
        isSuccess = validateBasicDetails();
        checkProcessStatus(isSuccess);
      } else if (_currentStep == 1) {
        isSuccess = validateLendingInfo();
        checkProcessStatus(isSuccess);
      } else if (_currentStep == 2) {
        isSuccess = validateDocumentDetails();
        checkProcessStatus(isSuccess);
      } else if (_currentStep == 3) {
        isSuccess = validateSecurityBasicDetails();
        checkProcessStatus(isSuccess);
      } else if (_currentStep == 4) {
        isSuccess = validateSecurityDocumentDetails();
        checkProcessStatus(isSuccess);
      }
    }
  }

  Future<bool> uploadAllImages() async {
    //Customer Photo
    String url = await uploadAndGetUrl(_basicDetails.photo);
    if (url.isEmpty) {
      return false;
    }
    _basicDetails.photo = url;

    //Customer documents
    for (int i = 0; i < _documents.documentProofs.length; ++i) {
      url = await uploadAndGetUrl(_documents.documentProofs[i]);
      if (url.isEmpty) {
        return false;
      }
      _documents.documentProofs[i] = url;
    }

    //Security Photo
    for (int i = 0; i < _securities.length; ++i) {
      url = await uploadAndGetUrl(_securities[i].photo);
      if (url.isEmpty) {
        return false;
      }
      _securities[i].photo = url;
    }

    //Security Documents
    for (int j = 0; j < _securitiesDocs.length; ++j) {
      for (int i = 0; i < _securitiesDocs[j].documentProofs.length; ++i) {
        url = await uploadAndGetUrl(_securitiesDocs[j].documentProofs[i]);
        if (url.isEmpty) {
          return false;
        }
        _securitiesDocs[j].documentProofs[i] = url;
      }
    }

    return true;
  }

  void updateData() async {
    displayLoading(true);
    bool ret = await uploadAllImages();
    ret = ret &&
        await DBManager.instance.performAddCustomer(_basicDetails, _lendingInfo,
            _documents, _securities, _securitiesDocs);
    if (ret) {
      Navigator.pop(context);
    } else {
      _currentStep -= 1;
      displayLoading(false);
      Utils.showErrorSnackBar(globalKey);
    }
  }

  void checkProcessStatus(bool isSuccess) {
    displayLoading(false);
    if (isSuccess == true) {
      Utils.showSuccessSnackBar(globalKey, text: "Successfully Validated...");
      _currentStep += 1;
      if (_formWidgets.length == _currentStep) {
        updateData();
      } else {
        setState(() {});
      }
    } else {
      Utils.showErrorSnackBar(globalKey);
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
