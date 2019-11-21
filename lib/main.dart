import 'package:flutter/material.dart';
import 'package:tracking_collections/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          buttonTheme: ButtonThemeData(
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
            textTheme: ButtonTextTheme.primary,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          accentIconTheme: IconThemeData(
            color: Colors.white,
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white,
          )),
      home: LoginScreen(),
    );
  }
}
