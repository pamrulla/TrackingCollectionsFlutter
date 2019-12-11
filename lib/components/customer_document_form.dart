import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_collections/components/add_circle_button.dart';
import 'package:tracking_collections/components/custom_text_from_field.dart';
import 'package:tracking_collections/components/remove_circle_button.dart';
import 'package:tracking_collections/models/documents.dart';
import 'package:tracking_collections/utils/utils.dart';

class CustomerDocumentForm extends StatefulWidget {
  final Function onContinue;
  final Function onBack;
  final Documents data;
  final GlobalKey<FormState> formKey;
  CustomerDocumentForm(
      {@required this.formKey,
      @required this.onContinue,
      @required this.onBack,
      @required this.data});

  @override
  _CustomerDocumentFormState createState() => _CustomerDocumentFormState();
}

class _CustomerDocumentFormState extends State<CustomerDocumentForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<FocusNode> _focusNodeDocumentName = [];
  List<TextEditingController> _textEditingControllerDocumentName = [];
  List<FocusNode> _focusNodeDocumentPath = [];
  List<TextEditingController> _textEditingControllerDocumentPath = [];
  List<bool> isImageChanged = [];

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey;
    _focusNodeDocumentName.clear();
    _textEditingControllerDocumentName.clear();
    _focusNodeDocumentPath.clear();
    _textEditingControllerDocumentPath.clear();
    isImageChanged.clear();

    if (widget.data.documentProofs.length == 0) {
      _focusNodeDocumentName.add(FocusNode());
      _textEditingControllerDocumentName.add(TextEditingController());
      _focusNodeDocumentPath.add(FocusNode());
      _textEditingControllerDocumentPath.add(TextEditingController());
      isImageChanged.add(false);
    } else {
      for (int i = 0; i < widget.data.documentProofs.length; ++i) {
        _focusNodeDocumentName.add(FocusNode());
        _textEditingControllerDocumentName.add(TextEditingController());
        _textEditingControllerDocumentName[i].text =
            widget.data.documentNames[i];
        _focusNodeDocumentPath.add(FocusNode());
        _textEditingControllerDocumentPath.add(TextEditingController());
        _textEditingControllerDocumentPath[i].text =
            widget.data.documentProofs[i];
        isImageChanged.add(false);
      }
    }
  }

  Widget getImage(int index) {
    if (isImageChanged[index]) {
      return Image.asset(
        _textEditingControllerDocumentPath[index].text,
        width: 200,
        height: 200,
      );
    } else if (widget.data.id.isNotEmpty &&
        _textEditingControllerDocumentPath[index].text.isNotEmpty) {
      return Image.network(
        _textEditingControllerDocumentPath[index].text,
        width: 200,
        height: 200,
      );
    } else if (widget.data.id.isEmpty &&
        _textEditingControllerDocumentPath[index].text.isNotEmpty) {
      return Image.asset(
        _textEditingControllerDocumentPath[index].text,
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

  void takePhoto(int index) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _textEditingControllerDocumentPath[index].text = image.path;
      isImageChanged[index] = true;
    });
  }

  void addNewSet() {
    _focusNodeDocumentName.add(FocusNode());
    _focusNodeDocumentPath.add(FocusNode());
    _textEditingControllerDocumentName.add(TextEditingController());
    _textEditingControllerDocumentPath.add(TextEditingController());
    isImageChanged.add(false);
    setState(() {});
  }

  Widget getAddRemoveButton(int index) {
    if (index == _focusNodeDocumentName.length - 1) {
      return AddCircleButton(
        onPressed: addNewSet,
      );
    } else {
      return RemoveCircleButton(
        index: index,
        onPressed: removeSet,
      );
    }
  }

  void removeSet(int index) {
    _focusNodeDocumentName.removeAt(index);
    _focusNodeDocumentPath.removeAt(index);
    _textEditingControllerDocumentName.removeAt(index);
    _textEditingControllerDocumentPath.removeAt(index);
    isImageChanged.removeAt(index);
    setState(() {});
  }

  List<Widget> getForm() {
    List<Widget> items = [];
    for (int i = 0; i < _focusNodeDocumentName.length; ++i) {
      Row r1 = Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: CustomTextFromField(
              focusNode: _focusNodeDocumentName[i],
              icon: Icons.verified_user,
              hintText: 'Document Name',
              validator: (value) {
                if (value.isEmpty) {
                  return 'Document Name should not be empty';
                }
                return null;
              },
              controller: _textEditingControllerDocumentName[i],
              onSaved: (val) {
                if (i >= widget.data.documentNames.length) {
                  widget.data.documentNames.add(val);
                } else {
                  widget.data.documentNames[i] = val;
                }
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (term) {
                Utils.closeKeyboard(context);
              },
            ),
          ),
          Expanded(
            child: getAddRemoveButton(i),
          )
        ],
      );
      Visibility v1 = Visibility(
        visible: false,
        maintainState: true,
        child: CustomTextFromField(
          focusNode: _focusNodeDocumentPath[i],
          icon: Icons.verified_user,
          hintText: 'Document Photo',
          validator: (value) {
            if (value.isEmpty) {
              return 'Document Photo should not be empty';
            }
            return null;
          },
          controller: _textEditingControllerDocumentPath[i],
          onSaved: (val) {
            if (i >= widget.data.documentProofs.length) {
              widget.data.documentProofs.add(val);
            } else {
              widget.data.documentProofs[i] = val;
            }
          },
          enabled: false,
        ),
      );
      GestureDetector g1 = GestureDetector(
        onTap: () {
          takePhoto(i);
        },
        child: getImage(i),
      );
      items.add(r1);
      items.add(v1);
      items.add(g1);
    }
    return items;
  }

  Widget buildBasicDetails() {
    return Form(
      key: _formKey,
      child: Column(
        children: getForm(),
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
