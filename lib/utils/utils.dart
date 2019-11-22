import 'package:flutter/material.dart';
import 'package:tracking_collections/screens/login_screen.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static void logOut(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static String getTodayDate() {
    DateTime dt = DateTime.now();
    String ret = '';
    ret += dt.day.toString();
    ret += ':';
    ret += dt.month.toString();
    ret += ':';
    ret += dt.year.toString();
    return ret;
  }
}
