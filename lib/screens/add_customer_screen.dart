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
import 'package:tracking_collections/viewmodels/CustomerBasicDetails.dart';

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
    "Security 1: Documents"
  ];
  List<GlobalKey<FormState>> keys = [];

  BasicDetails _basicDetails = BasicDetails();
  LendingInfo _lendingInfo = LendingInfo();
  Documents _documents = Documents();
  List<BasicDetails> _securities = [];
  List<Documents> _securitiesDocs = [];

  String _previousCustomerPhoto = '';
  List<String> _previousCustomerDocuments = [];
  List<String> _previousSecurityPhoto = [];
  List<List<String>> _previousSecurityDocuments = [];

  void initSettings() async {
    displayLoading(true);
    if (isEditMode()) {
      await editCustomerBasicSettings();
    } else {
      newCustomerBasicSettings();
    }
    displayLoading(false);
  }

  bool isEditMode() {
    return widget.currentCustomer.isNotEmpty;
  }

  Future<void> editCustomerBasicSettings() async {
    CustomerBasicDetails _customerBasicDetailsFuture = await DBManager.instance
        .getCustomerBasicDetails(widget.currentCustomer);
    List<CustomerBasicDetails> _securityBasicDetailsFuture =
        await DBManager.instance.getSecurityDetails(widget.currentCustomer);

    _basicDetails = _customerBasicDetailsFuture.basicDetails;
    _lendingInfo = _customerBasicDetailsFuture.lendingInfo;
    _documents = _customerBasicDetailsFuture.documents;
    _securities.clear();
    _securitiesDocs.clear();
    for (int i = 0; i < _securityBasicDetailsFuture.length; ++i) {
      _securities.add(_securityBasicDetailsFuture[i].basicDetails);
      _securitiesDocs.add(_securityBasicDetailsFuture[i].documents);
    }

    if (_securities.length > 1) {
      for (int i = 1; i < _securities.length; ++i) {
        _subTitles.add("Security " + (i + 1).toString() + ": Basic Details");
        _subTitles.add("Security " + (i + 1).toString() + ": Documents");
      }
    }

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
    int keyIndex = 3;
    for (int i = 0; i < _securities.length; ++i) {
      _formWidgets.add(CustomerBasicDetailsForm(
        formKey: keys[keyIndex],
        onBack: onBack,
        onContinue: onContinue,
        data: _securities[i],
      ));
      keyIndex += 1;
      _formWidgets.add(CustomerDocumentForm(
        formKey: keys[keyIndex],
        onBack: onBack,
        onContinue: onContinue,
        data: _securitiesDocs[i],
      ));
    }

    updatePreviousInfo();
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
    String currentSubTitle = "";
    if (_currentStep < _subTitles.length) {
      currentSubTitle = _subTitles[_currentStep];
      int cs = _currentStep + 1;
      currentSubTitle +=
          " (" + cs.toString() + "/" + _formWidgets.length.toString() + ")";
    }
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
    bool isChanged = true;
    String url = '';

    //Customer Photo
    isChanged = _basicDetails.photo != _previousCustomerPhoto;
    if (isChanged) {
      url = await uploadAndGetUrl(_basicDetails.photo);
      if (url.isEmpty) {
        return false;
      }
      _basicDetails.photo = url;
    }

    //Customer documents
    for (int i = 0; i < _documents.documentProofs.length; ++i) {
      if (i < _previousCustomerDocuments.length) {
        isChanged =
            _documents.documentProofs[i] != _previousCustomerDocuments[i];
      } else {
        isChanged = true;
      }
      if (isChanged) {
        url = await uploadAndGetUrl(_documents.documentProofs[i]);
        if (url.isEmpty) {
          return false;
        }
        _documents.documentProofs[i] = url;
      }
    }

    //Security Photo
    for (int i = 0; i < _securities.length; ++i) {
      if (i < _previousSecurityPhoto.length) {
        isChanged = _securities[i].photo != _previousSecurityPhoto[i];
      } else {
        isChanged = true;
      }
      if (isChanged) {
        url = await uploadAndGetUrl(_securities[i].photo);
        if (url.isEmpty) {
          return false;
        }
        _securities[i].photo = url;
      }
    }

    //Security Documents
    for (int j = 0; j < _securitiesDocs.length; ++j) {
      for (int i = 0; i < _securitiesDocs[j].documentProofs.length; ++i) {
        if (j < _previousSecurityDocuments.length) {
          if (i < _previousSecurityDocuments[j].length) {
            isChanged = _securitiesDocs[j].documentProofs[i] !=
                _previousSecurityDocuments[j][i];
          } else {
            isChanged = true;
          }
        } else {
          isChanged = true;
        }
        if (isChanged) {
          url = await uploadAndGetUrl(_securitiesDocs[j].documentProofs[i]);
          if (url.isEmpty) {
            return false;
          }
          _securitiesDocs[j].documentProofs[i] = url;
        }
      }
    }

    return true;
  }

  void updateData() async {
    displayLoading(true);
    bool ret = await uploadAllImages();
    if (isEditMode()) {
      ret = ret &&
          await DBManager.instance.performUpdateCustomer(_basicDetails,
              _lendingInfo, _documents, _securities, _securitiesDocs);
    } else {
      ret = ret &&
          await DBManager.instance.performAddCustomer(_basicDetails,
              _lendingInfo, _documents, _securities, _securitiesDocs);
    }
    if (ret) {
      Navigator.pop(context, true);
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

  void updatePreviousInfo() {
    _previousCustomerPhoto = _basicDetails.photo;
    for (int i = 0; i < _documents.documentProofs.length; ++i) {
      _previousCustomerDocuments.add(_documents.documentProofs[i]);
    }
    for (int i = 0; i < _securities.length; ++i) {
      _previousSecurityPhoto.add(_securities[i].photo);
      List<String> docs = [];
      for (int j = 0; j < _securitiesDocs[i].documentProofs.length; ++j) {
        docs.add(_securitiesDocs[i].documentProofs[j]);
      }
      _previousSecurityDocuments.add(docs);
    }
  }
}
