import 'package:flutter/material.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/utils/utils.dart';

class CustomerLendingInfoForm extends StatefulWidget {
  final Function onContinue;
  final Function onBack;
  GlobalKey<FormState> formKey;
  CustomerLendingInfoForm(
      {@required this.formKey,
      @required this.onContinue,
      @required this.onBack});

  @override
  _CustomerLendingInfoFormState createState() =>
      _CustomerLendingInfoFormState();
}

class _CustomerLendingInfoFormState extends State<CustomerLendingInfoForm> {
  GlobalKey<FormState> _formKey;
  FocusNode _focusNodeDate = FocusNode();
  TextEditingController _textEditingControllerDate = TextEditingController();
  FocusNode _focusNodeAmount = FocusNode();
  TextEditingController _textEditingControllerAmount = TextEditingController();
  FocusNode _focusNodeMonths = FocusNode();
  TextEditingController _textEditingControllerMonths = TextEditingController();
  FocusNode _focusNodeInterestRate = FocusNode();
  TextEditingController _textEditingControllerInterestRate =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey;
    _textEditingControllerDate.text = Utils.getTodayDate();
  }

  Widget buildBasicDetails() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
            onSaved: (val) {},
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(context, _focusNodeDate, _focusNodeAmount);
            },
            enabled: false,
          ),
          CustomTextFromField(
            focusNode: _focusNodeAmount,
            icon: Icons.verified_user,
            hintText: 'Lending Amount',
            validator: (value) {
              if (value.isEmpty) {
                return 'Lending Amount should not be empty';
              } else if (Utils.isNumeric(value)) {
                return 'Lending Amount is invalid';
              }
              return null;
            },
            controller: _textEditingControllerAmount,
            onSaved: (val) {},
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodeAmount, _focusNodeMonths);
            },
            keyboardType: TextInputType.number,
          ),
          CustomTextFromField(
            focusNode: _focusNodeMonths,
            icon: Icons.verified_user,
            hintText: 'Months',
            validator: (value) {
              if (value.isEmpty) {
                return 'Months should not be empty';
              } else if (Utils.isNumeric(value)) {
                return 'Months is invalid';
              }
              return null;
            },
            controller: _textEditingControllerMonths,
            onSaved: (val) {},
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodeMonths, _focusNodeInterestRate);
            },
            keyboardType: TextInputType.number,
          ),
          CustomTextFromField(
            focusNode: _focusNodeInterestRate,
            icon: Icons.verified_user,
            hintText: 'Interest Rate',
            validator: (value) {
              if (value.isEmpty) {
                return 'Interest Rate should not be empty';
              } else if (Utils.isNumeric(value)) {
                return 'Interest Rate is invalid';
              }
              return null;
            },
            controller: _textEditingControllerInterestRate,
            onSaved: (val) {},
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.closeKeyboard(context);
            },
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Center(
              child: buildBasicDetails(),
            ),
          ),
        ),
      ],
    );
  }
}
