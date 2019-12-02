import 'package:flutter/material.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/loading_please_wait.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/models/transaction.dart';
import 'package:tracking_collections/utils/utils.dart';

class AmountRecieveBottomScreen extends StatefulWidget {
  final String title;
  final String customer;
  AmountRecieveBottomScreen(this.title, this.customer);

  @override
  _AmountRecieveBottomScreenState createState() =>
      _AmountRecieveBottomScreenState();
}

class _AmountRecieveBottomScreenState extends State<AmountRecieveBottomScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeDate = FocusNode();
  TextEditingController _textEditingControllerDate = TextEditingController();
  FocusNode _focusNodeAmount = FocusNode();
  TextEditingController _textEditingControllerAmount = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  Transaction trans = Transaction();
  bool isLoading = false;

  void displayLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    trans.customer = widget.customer;
    trans.amount = 0;
    trans.date = DateTime.now();
    //TODO Agent
    trans.agent = '';
    trans.type = widget.title.contains('Penalty') ? 1 : 0;
    _textEditingControllerDate.text = Utils.getDateDisplayFormat(trans.date);
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
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
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
                                    widget.title,
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
                                    focusNode: _focusNodeDate,
                                    icon: Icons.verified_user,
                                    hintText: 'Start Date',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Date should not be empty';
                                      }
                                      return null;
                                    },
                                    controller: _textEditingControllerDate,
                                    onSaved: (val) {
                                      //trans.date = DateTime.parse(val);
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      Utils.fieldFocusChange(context,
                                          _focusNodeDate, _focusNodeAmount);
                                    },
                                    enabled: false,
                                  ),
                                  CustomTextFromField(
                                    focusNode: _focusNodeAmount,
                                    icon: Icons.verified_user,
                                    hintText: 'Amount',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Amount should not be empty';
                                      } else if (!Utils.isNumeric(value)) {
                                        return 'Amount is invalid';
                                      }
                                      return null;
                                    },
                                    controller: _textEditingControllerAmount,
                                    onSaved: (val) {
                                      trans.amount = double.parse(val);
                                    },
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (term) {
                                      Utils.closeKeyboard(context);
                                    },
                                    keyboardType: TextInputType.number,
                                  ),
                                  MyRaisedButton(
                                    name: 'Submit',
                                    onPressed: performTransaction,
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

  void performTransaction() async {
    if (_formKey.currentState.validate()) {
      displayLoading(true);
      _formKey.currentState.save();
      bool isSuccess = await DBManager.instance.addTransaction(trans);
      displayLoading(false);
      if (isSuccess)
        Navigator.pop(context, trans);
      else {
        Utils.showErrorSnackBar(_globalKey,
            text:
                'Something went wrong while performing transaction, please try again...');
      }
    }
  }
}
