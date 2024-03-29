import 'package:flutter/material.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/show_select_city.dart';
import 'package:tracking_collections/models/lending_info.dart';
import 'package:tracking_collections/utils/utils.dart';

class CustomerLendingInfoForm extends StatefulWidget {
  final Function onContinue;
  final Function onBack;
  final LendingInfo data;
  final GlobalKey<FormState> formKey;
  CustomerLendingInfoForm({
    @required this.formKey,
    @required this.onContinue,
    @required this.onBack,
    @required this.data,
  });

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

    if (widget.data.id.isEmpty) {
      widget.data.date = DateTime.now();
    }
    _textEditingControllerDate.text =
        Utils.getDateDisplayFormat(widget.data.date);
    _textEditingControllerAmount.text = widget.data.amount.toString();
    _textEditingControllerMonths.text = widget.data.months.toString();
    _textEditingControllerInterestRate.text =
        widget.data.interestRate.toString();
  }

  Widget buildBasicDetails() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ShowSelectCity(
              city: widget.data.city,
              onSelected: (value) {
                widget.data.city = value.id;
              },
            ),
          ),
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
              //widget.data.date = val;
            },
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
              } else if (!Utils.isNumeric(value)) {
                return 'Lending Amount is invalid';
              } else {
                double val = double.parse(value);
                if (val <= 0) {
                  return 'Lending Amount should be greater than zero.';
                }
              }
              return null;
            },
            controller: _textEditingControllerAmount,
            onSaved: (val) {
              widget.data.amount = double.parse(val);
            },
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
            hintText: 'Months/Weeks/Days',
            validator: (value) {
              if (value.isEmpty) {
                return 'Months/Weeks/Days should not be empty';
              } else if (!Utils.isNumeric(value)) {
                return 'Months/Weeks/Days is invalid';
              } else {
                double val = double.parse(value);
                if (val <= 0) {
                  return 'Months/Weeks/Days should be greater than zero.';
                }
              }
              return null;
            },
            controller: _textEditingControllerMonths,
            onSaved: (val) {
              widget.data.months = int.parse(val);
            },
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
              } else if (!Utils.isNumeric(value)) {
                return 'Interest Rate is invalid';
              } else {
                double val = double.parse(value);
                if (val <= 0) {
                  return 'Interest Rate should be greater than zero.';
                }
              }
              return null;
            },
            controller: _textEditingControllerInterestRate,
            onSaved: (val) {
              widget.data.interestRate = double.parse(val);
            },
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
