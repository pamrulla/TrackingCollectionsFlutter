import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/cities_popupmenubutton.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/form_sub_heading_text.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/screens/add_customer_screen.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class NewLineScreen extends StatefulWidget {
  @override
  _NewLineScreenState createState() => _NewLineScreenState();
}

class _NewLineScreenState extends State<NewLineScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DurationEnum _duration = DurationEnum.Monthly;
  FocusNode _focusNodeAgentName = FocusNode();
  FocusNode _focusNodeAgentNumber = FocusNode();
  static final TextEditingController _textEditingControllerAgentName =
      TextEditingController();
  static final TextEditingController _textEditingControllerAgentNumber =
      TextEditingController();

  String _agentName = '';
  String _agentNumber = '';

  @override
  void initState() {
    super.initState();
    _textEditingControllerAgentName.clear();
    _textEditingControllerAgentNumber.clear();
  }

  List<ListTile> getDurationRadioButtons() {
    List<ListTile> radioButtons = [];
    for (int i = 0; i < DurationEnum.values.length; ++i) {
      ListTile lt = ListTile(
        title: Text(durations[i]),
        leading: Radio(
          value: DurationEnum.values[i],
          groupValue: _duration,
          onChanged: (DurationEnum value) {
            setState(() {
              _duration = value;
            });
          },
        ),
      );
      radioButtons.add(lt);
    }
    return radioButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: 'New Line',
          subTitle: 'Adding Agent(s)',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 9,
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
                            FormSubHeadingText(
                              text: 'Select Duration:',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: getDurationRadioButtons(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: FormSubHeadingText(
                                      text: 'Select City:',
                                    ),
                                  ),
                                  Expanded(
                                    child: CitiesPopUpMenuButton(
                                      onSelected: (value) {},
                                    ),
                                  )
                                ],
                              ),
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
                                            _agentName = val;
                                          });
                                        },
                                        textInputAction: TextInputAction.next,
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
                                          if (value.isEmpty ||
                                              !Utils.isNumeric(value) ||
                                              value.length < 10) {
                                            return 'Agent Number should not be empty';
                                          }
                                          return null;
                                        },
                                        controller:
                                            _textEditingControllerAgentNumber,
                                        onSaved: (val) {
                                          setState(() {
                                            _agentName = val;
                                          });
                                        },
                                        textInputAction: TextInputAction.done,
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
                                  color: Theme.of(context).primaryColorLight,
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
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: MyRaisedButton(
                  name: 'Add Agent(s)',
                  onPressed: _onAddingAgent,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _onAddingAgent() async {
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
}
