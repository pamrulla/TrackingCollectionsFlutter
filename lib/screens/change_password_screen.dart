import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/utils/auth.dart';
import 'package:tracking_collections/utils/utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeConfirmPassword = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  static final TextEditingController _textEditingControllerConfirmPassword =
      TextEditingController();
  static final TextEditingController _textEditingControllerPassword =
      TextEditingController();

  String _userConfirmPassword = '';
  String _password = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _textEditingControllerPassword.clear();
    _textEditingControllerConfirmPassword.clear();
    DBManager.instance.getCitiesList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: AppbarTitileWithSubtitle(title: 'Change Password'),
          actions: <Widget>[
            Logout(),
          ],
        ),
        body: _isProcessing
            ? LoadingPleaseWait()
            : Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Hero(
                                    tag: 'logo',
                                    child: Image.asset(
                                      'images/logo.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                  ),
                                  CustomTextFromField(
                                    focusNode: _focusNodeConfirmPassword,
                                    icon: Icons.verified_user,
                                    hintText: 'Password',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Password should not be empty';
                                      }
                                      return null;
                                    },
                                    controller:
                                        _textEditingControllerConfirmPassword,
                                    onSaved: (val) {
                                      setState(() {
                                        _userConfirmPassword = val;
                                      });
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      Utils.fieldFocusChange(
                                          context,
                                          _focusNodeConfirmPassword,
                                          _focusNodePassword);
                                    },
                                    obscureText: true,
                                  ),
                                  CustomTextFromField(
                                    focusNode: _focusNodePassword,
                                    icon: Icons.verified_user,
                                    hintText: 'Confirm Password',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Password should not be empty';
                                      }
                                      return null;
                                    },
                                    controller: _textEditingControllerPassword,
                                    onSaved: (val) {
                                      setState(() {
                                        _password = val;
                                      });
                                    },
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.visiblePassword,
                                    onFieldSubmitted: (term) {
                                      Utils.closeKeyboard(context);
                                    },
                                    obscureText: true,
                                  ),
                                  Center(
                                    child: Text(
                                      '- Minimum length should be 6 characters',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  MyRaisedButton(
                                    name: 'Change Password',
                                    onPressed: onSubmit,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void setLoading(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  void onSubmit() async {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      if (_userConfirmPassword != _password) {
        Utils.showErrorSnackBar(_globalKey,
            text: "Both passwords should match");
        return;
      }
      setLoading(true);
      bool ret = await Authorization().changePassword(_password);
      setLoading(false);
      if (ret) {
        Utils.showSuccessSnackBar(_globalKey,
            text: "Success fully changed password, please login again...");
        sleep(Duration(seconds: 1));
        Utils.logOut(context);
      } else {
        Utils.showErrorSnackBar(_globalKey,
            text: "Password change failed, please try again...");
      }
    }
  }
}
