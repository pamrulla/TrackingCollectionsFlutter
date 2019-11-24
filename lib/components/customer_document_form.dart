import 'package:flutter/material.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/utils/utils.dart';

class CustomerDocumentForm extends StatefulWidget {
  final Function onContinue;
  final Function onBack;
  GlobalKey<FormState> formKey;
  CustomerDocumentForm(
      {@required this.formKey,
      @required this.onContinue,
      @required this.onBack});

  @override
  _CustomerDocumentFormState createState() => _CustomerDocumentFormState();
}

class _CustomerDocumentFormState extends State<CustomerDocumentForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeDocumentName = FocusNode();
  TextEditingController _textEditingControllerDocumentName =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey;
  }

  Widget buildBasicDetails() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CustomTextFromField(
            focusNode: _focusNodeDocumentName,
            icon: Icons.verified_user,
            hintText: 'Document Name',
            validator: (value) {
              if (value.isEmpty) {
                return 'Document Name should not be empty';
              }
              return null;
            },
            controller: _textEditingControllerDocumentName,
            onSaved: (val) {},
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (term) {
              Utils.closeKeyboard(context);
            },
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
