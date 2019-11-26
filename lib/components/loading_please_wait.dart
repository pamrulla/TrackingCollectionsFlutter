import 'package:flutter/material.dart';
import 'package:tracking_collections/components/form_sub_heading_text.dart';

class LoadingPleaseWait extends StatelessWidget {
  const LoadingPleaseWait({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20.0,),
          FormSubHeadingText(
            text: 'Processing please wait...',
          ),
        ],
      ),
    );
  }
}
