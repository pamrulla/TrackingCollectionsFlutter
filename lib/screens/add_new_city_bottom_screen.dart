import 'package:flutter/material.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class AddNewCityBottomScreen extends StatefulWidget {
  AddNewCityBottomScreen();

  @override
  _AddNewCityBottomScreenState createState() => _AddNewCityBottomScreenState();
}

class _AddNewCityBottomScreenState extends State<AddNewCityBottomScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeName = FocusNode();
  TextEditingController _textEditingControllerName = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String _cityName = '';
  bool isLoading = false;

  void displayLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: isLoading
          ? LoadingPleaseWait()
          : Container(
              color: Color(0xff757575),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'Add New Line Name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(),
                                  CustomTextFromField(
                                    focusNode: _focusNodeName,
                                    icon: Icons.verified_user,
                                    hintText: 'New Line Name',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'New Line Name should not be empty';
                                      }
                                      return null;
                                    },
                                    controller: _textEditingControllerName,
                                    onSaved: (val) {
                                      _cityName = val;
                                    },
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (term) {
                                      Utils.closeKeyboard(context);
                                    },
                                  ),
                                  MyRaisedButton(
                                    name: 'Add New City',
                                    onPressed: performAction,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void performAction() async {
    if (_formKey.currentState.validate()) {
      displayLoading(true);
      _formKey.currentState.save();
      City temp = cities.singleWhere((c) {
        return c.name.toLowerCase() == _cityName.toLowerCase();
      }, orElse: () {
        return null;
      });
      if (temp != null) {
        displayLoading(false);
        Utils.showErrorSnackBar(_globalKey,
            text: 'Entered Name already exists');
        return;
      }
      String isSuccess = await DBManager.instance.addNewCity(_cityName);
      displayLoading(false);
      if (isSuccess != null && isSuccess.isNotEmpty) {
        Navigator.pop(context, isSuccess);
      } else {
        Utils.showErrorSnackBar(_globalKey,
            text:
                'Something went wrong while adding city, please try again...');
      }
    }
  }
}
