import 'package:flutter/material.dart';
import 'package:tracking_collections/components/appbar_title_with_subtitle.dart';
import 'package:tracking_collections/components/goto_home_widget.dart';
import 'package:tracking_collections/components/logout_widget.dart';

class ImageViewer extends StatelessWidget {
  final String img;
  final String title;
  ImageViewer(String src, {@required this.title}) : img = src;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitileWithSubtitle(
          title: title,
        ),
        actions: <Widget>[
          GotoHome(),
          Logout(),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.network(img),
            )
          ],
        ),
      ),
    );
  }
}
