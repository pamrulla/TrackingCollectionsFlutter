import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/models/basic_details.dart';
import 'package:tracking_collections/utils/utils.dart';

class CustomerBasicDetailsForm extends StatefulWidget {
  final Function onContinue;
  final Function onBack;
  final BasicDetails data;
  GlobalKey<FormState> formKey;
  CustomerBasicDetailsForm(
      {@required this.formKey,
      @required this.onContinue,
      @required this.onBack,
      @required this.data});

  @override
  _CustomerBasicDetailsFormState createState() =>
      _CustomerBasicDetailsFormState();
}

class _CustomerBasicDetailsFormState extends State<CustomerBasicDetailsForm> {
  GlobalKey<FormState> _formKey;
  bool _sameAsPermanentAddress = false;
  FocusNode _focusNodeName = FocusNode();
  TextEditingController _textEditingControllerName = TextEditingController();
  FocusNode _focusNodeOccupation = FocusNode();
  TextEditingController _textEditingControllerOccupation =
      TextEditingController();
  FocusNode _focusNodeFatherName = FocusNode();
  TextEditingController _textEditingControllerFatherName =
      TextEditingController();
  FocusNode _focusNodeAdharNumber = FocusNode();
  TextEditingController _textEditingControllerAdharNumber =
      TextEditingController();
  FocusNode _focusNodePermanentAddress = FocusNode();
  TextEditingController _textEditingControllerPermanentAddress =
      TextEditingController();
  FocusNode _focusNodeTemporaryAddress = FocusNode();
  TextEditingController _textEditingControllerTemporaryAddress =
      TextEditingController();
  FocusNode _focusNodePhone = FocusNode();
  TextEditingController _textEditingControllerPhone = TextEditingController();

  File _image = null;

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey;
  }

  void takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      widget.data.photo = _image.path;
    });
  }

  Widget getImage() {
    if (_image != null) {
      return Image.file(
        _image,
        width: 200,
        height: 200,
      );
    }
    return Image.asset(
      'images/profile.jpg',
      width: 200,
      height: 200,
    );
  }

  Widget buildBasicDetails() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: takePhoto,
            child: getImage(),
          ),
          CustomTextFromField(
            focusNode: _focusNodeName,
            icon: Icons.verified_user,
            hintText: 'Name',
            validator: (value) {
              if (value.isEmpty) {
                return 'Name should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerName,
            onSaved: (val) {
              widget.data.name = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodeName, _focusNodeFatherName);
            },
          ),
          CustomTextFromField(
            focusNode: _focusNodeFatherName,
            icon: Icons.verified_user,
            hintText: 'Father Name',
            validator: (value) {
              if (value.isEmpty) {
                return 'Father Name should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerFatherName,
            onSaved: (val) {
              widget.data.fatherName = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodeFatherName, _focusNodeOccupation);
            },
          ),
          CustomTextFromField(
            focusNode: _focusNodeOccupation,
            icon: Icons.verified_user,
            hintText: 'Occupation',
            validator: (value) {
              if (value.isEmpty) {
                return 'Occupation should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerOccupation,
            onSaved: (val) {
              widget.data.occupation = val;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodeOccupation, _focusNodeAdharNumber);
            },
          ),
          CustomTextFromField(
            focusNode: _focusNodeAdharNumber,
            icon: Icons.verified_user,
            hintText: 'Adhar Number',
            validator: (value) {
              if (value.isEmpty || !Utils.isNumeric(value)) {
                return 'Adhar Number should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerAdharNumber,
            onSaved: (val) {
              widget.data.adharNumber = val;
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodeAdharNumber, _focusNodePhone);
            },
          ),
          CustomTextFromField(
            focusNode: _focusNodePhone,
            icon: Icons.verified_user,
            hintText: 'Phone Number',
            validator: (value) {
              if (value.isEmpty || !Utils.isNumeric(value)) {
                return 'Phone Number should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerPhone,
            onSaved: (val) {},
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (term) {
              Utils.fieldFocusChange(
                  context, _focusNodePhone, _focusNodePermanentAddress);
            },
          ),
          CheckboxListTile(
            title: Text('Same As Permanant Address'),
            value: _sameAsPermanentAddress,
            onChanged: (value) {
              setState(() {
                _sameAsPermanentAddress = value;
                widget.data.isSameAsPermanentAddress = value;
              });
            },
          ),
          CustomTextFromField(
            focusNode: _focusNodePermanentAddress,
            icon: Icons.verified_user,
            hintText: 'Permanant Address',
            validator: (value) {
              if (value.isEmpty) {
                return 'Permanant Address should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerPermanentAddress,
            onSaved: (val) {
              widget.data.permanentAddress = val;
            },
            textInputAction: _sameAsPermanentAddress
                ? TextInputAction.done
                : TextInputAction.next,
            onFieldSubmitted: (term) {
              if (_sameAsPermanentAddress) {
                Utils.closeKeyboard(context);
              } else {
                Utils.fieldFocusChange(context, _focusNodePermanentAddress,
                    _focusNodeTemporaryAddress);
              }
            },
          ),
          CustomTextFromField(
            focusNode: _focusNodeTemporaryAddress,
            icon: Icons.verified_user,
            hintText: 'Current Address',
            validator: (value) {
              if (_sameAsPermanentAddress == false && value.isEmpty) {
                return 'Current Address should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerTemporaryAddress,
            onSaved: (val) {
              widget.data.temporaryAddress = val;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (term) {
              Utils.closeKeyboard(context);
            },
            enabled: !_sameAsPermanentAddress,
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
