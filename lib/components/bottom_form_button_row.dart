import 'package:flutter/material.dart';
import 'package:tracking_collections/components/myRaisedButton.dart';
import 'package:tracking_collections/components/my_outline_button.dart';

class ButtomFormButtonRow extends StatelessWidget {
  final Function onContinue;
  final Function onBack;
  ButtomFormButtonRow({@required this.onContinue, @required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MyOutlineButton(
              name: 'Back',
              onPressed: onBack,
            ),
          ),
        ),
        Expanded(
          child: MyRaisedButton(
            name: 'Continue...',
            onPressed: onContinue,
          ),
        ),
      ],
    );
  }
}
