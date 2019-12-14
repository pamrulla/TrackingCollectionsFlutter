import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/bottom_navigation_bar.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/form_sub_heading_text.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/logout_widget.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/components/show_select_city.dart';
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/screens/add_new_city_bottom_screen.dart';
import 'package:tracking_collections/utils/auth.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';

class NewLineScreen extends StatefulWidget {
  @override
  _NewLineScreenState createState() => _NewLineScreenState();
}

class _NewLineScreenState extends State<NewLineScreen> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DurationEnum _duration = DurationEnum.Monthly;
  FocusNode _focusNodeAgentName = FocusNode();
  FocusNode _focusNodeAgentNumber = FocusNode();
  static final TextEditingController _textEditingControllerAgentName =
      TextEditingController();
  static final TextEditingController _textEditingControllerAgentNumber =
      TextEditingController();

  Agent agent = Agent();
  bool isLoading = false;
  City newCity = City();
  String _addedCity = '';

  @override
  void initState() {
    super.initState();
    _textEditingControllerAgentName.clear();
    _textEditingControllerAgentNumber.clear();
    agent.city.add(cities[0].id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'New Line',
          subTitle: 'Adding Agent(s)',
        ),
        actions: <Widget>[
          GotoHome(),
          Logout(),
        ],
      ),
      bottomNavigationBar: MyBottomnaviationBar(
        onTap: _onAddingAgent,
      ),
      body: isLoading
          ? LoadingPleaseWait()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          ShowSelectCity(
                                            city: _addedCity,
                                            onSelected: (value) {
                                              agent.city[0] = value.id;
                                            },
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            'OR',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          MyRaisedButton(
                                            name: 'Add New Line Name',
                                            onPressed: doAddNewLine,
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      width: 2.0,
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            FormSubHeadingText(
                                              text: 'Enter Agent Details:',
                                            ),
                                            CustomTextFromField(
                                              focusNode: _focusNodeAgentName,
                                              icon: Icons.verified_user,
                                              hintText: 'Agent Name',
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Agent Name should not be empty';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  _textEditingControllerAgentName,
                                              onSaved: (val) {
                                                setState(() {
                                                  agent.name = val;
                                                });
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              onFieldSubmitted: (term) {
                                                Utils.fieldFocusChange(
                                                    context,
                                                    _focusNodeAgentName,
                                                    _focusNodeAgentNumber);
                                              },
                                            ),
                                            CustomTextFromField(
                                              focusNode: _focusNodeAgentNumber,
                                              icon: Icons.verified_user,
                                              hintText: 'Agent Number',
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Agent Number should not be empty';
                                                }
                                                if (!Utils.isNumeric(value)) {
                                                  return 'Agent Number is invalid';
                                                }
                                                if (value.length != 10) {
                                                  return 'Agent Number should be of 10 digits length';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  _textEditingControllerAgentNumber,
                                              onSaved: (val) {
                                                setState(() {
                                                  agent.number = val;
                                                });
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              onFieldSubmitted: (term) {
                                                Utils.closeKeyboard(context);
                                              },
                                              keyboardType: TextInputType.phone,
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 2.0,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> onSuccess() async {
    int result = await showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Success...',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Where do you want to go?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Home'),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
            FlatButton(
              child: Text('Add New Customer'),
              onPressed: () {
                Navigator.of(context).pop(2);
              },
            ),
          ],
        );
      },
    );
    if (result == 1) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return AddCustomerScreen(
            currentMode: _duration,
          );
        }),
      );
    }
  }

  void displayLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> _onAddingAgent(int value) async {
    if (value == 1) {
      if (_formKey.currentState.validate()) {
        displayLoading(true);
        _formKey.currentState.save();
        agent.head = currentAgent.id;
        agent.role = 'agent';
        List<String> creds = await Authorization().createAgentLogin(agent.name);
        bool isSuccess = true;
        if (creds.length != 3) {
          isSuccess = false;
        } else {
          agent.userId = creds[2];
          isSuccess = await DBManager.instance.addAgent(agent);
          if (isSuccess) {
            String msg = 'username: ' + creds[0] + "\npassword: " + creds[1];
            if (await FlutterSms.canSendSMS()) {
              await FlutterSms.sendSMS(message: msg, recipients: [agent.number])
                  .catchError((e) {
                isSuccess = false;
              });
            }
            //if (await canLaunch(url)) {
            //  await launch(url);
            //}
          }
        }
        displayLoading(false);
        if (isSuccess) {
          Navigator.pop(context);
          //await onSuccess();
        } else {
          Utils.showErrorSnackBar(globalKey);
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  void doAddNewLine() async {
    String ret = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return AddNewCityBottomScreen();
      },
    );
    if (ret != null && ret.isNotEmpty) {
      setState(() {
        _addedCity = ret;
      });
    }
  }
}
