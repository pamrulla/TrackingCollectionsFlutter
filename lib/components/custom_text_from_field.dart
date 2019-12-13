import 'package:flutter/material.dart';
import 'package:tracking_collections/components/ensurevisiblewhenfocused.dart';

class CustomTextFromField extends StatelessWidget {
  final FocusNode focusNode;
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final TextInputAction textInputAction;
  final int minLines;
  final int maxLines;
  final ValueChanged<String> onFieldSubmitted;
  final int maxLength;
  final bool obscureText;
  final bool enabled;

  CustomTextFromField(
      {@required this.focusNode,
      @required this.icon,
      @required this.hintText,
      this.keyboardType,
      @required this.validator,
      @required this.controller,
      @required this.onSaved,
      this.textInputAction,
      this.minLines = 1,
      this.maxLines = 1,
      this.onFieldSubmitted,
      this.maxLength,
      this.obscureText = false,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          style: TextStyle(
            //color: kSecondaryColor,
            fontSize: 16.0,
          ),
          decoration: InputDecoration(
            //icon: Icon(
            //  icon,
            //color: kSecondaryLightColor,
            //  size: 30,
            //),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                //color: Color(0xaa904eb0),
                ),
            labelText: hintText,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(50.0),
              borderSide: new BorderSide(),
            ),
          ),
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          validator: validator,
          focusNode: focusNode,
          controller: controller,
          onSaved: onSaved,
          textInputAction: textInputAction ?? TextInputAction.none,
          onFieldSubmitted: onFieldSubmitted,
          maxLength: maxLength,
          obscureText: obscureText,
          enabled: enabled,
        ),
      ),
    );
  }
}
