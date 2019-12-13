import 'package:flutter/material.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/change_password_screen.dart';
import 'package:tracking_collections/screens/main_screen.dart';
import 'package:tracking_collections/utils/auth.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeUserName = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  static final TextEditingController _textEditingControllerUserName =
      TextEditingController();
  static final TextEditingController _textEditingControllerPassword =
      TextEditingController();

  String _userName = '';
  String _password = '';
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    _textEditingControllerPassword.clear();
    _textEditingControllerUserName.clear();
    DBManager.instance.getCitiesList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        body: _isLoggingIn
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
                                    focusNode: _focusNodeUserName,
                                    icon: Icons.verified_user,
                                    hintText: 'Username',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Username should not be empty';
                                      }
                                      return null;
                                    },
                                    controller: _textEditingControllerUserName,
                                    onSaved: (val) {
                                      setState(() {
                                        _userName = val;
                                      });
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      Utils.fieldFocusChange(
                                          context,
                                          _focusNodeUserName,
                                          _focusNodePassword);
                                    },
                                  ),
                                  CustomTextFromField(
                                    focusNode: _focusNodePassword,
                                    icon: Icons.verified_user,
                                    hintText: 'Password',
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
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  MyRaisedButton(
                                    name: 'Login',
                                    onPressed: onLogin,
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

  void setLoggingIn(bool value) {
    setState(() {
      _isLoggingIn = value;
    });
  }

  void onLogin() async {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      setLoggingIn(true);
      bool ret = await Authorization().logIn(_userName, _password);
      setLoggingIn(false);
      if (ret) {
        if (currentAgent.isFirstTime) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return ChangePasswordScreen();
          }));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MainScreen();
          }));
        }
      } else {
        Utils.showErrorSnackBar(_globalKey,
            text: "Authentication failed, please try again...");
      }
    }
  }
}
