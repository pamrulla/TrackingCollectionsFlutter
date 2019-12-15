import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracking_collections/components/error_snackbar.dart';
import 'package:tracking_collections/components/success_snackbar.dart';
import 'package:tracking_collections/screens/login_screen.dart';
import 'package:tracking_collections/utils/auth.dart';
import 'package:tracking_collections/utils/globals.dart';

class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static void logOut(BuildContext context) async {
    await Authorization().logOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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

  static String getDateDisplayFormat(DateTime dt) {
    String ret = '';
    ret += dt.day.toString();
    ret += ':';
    ret += dt.month.toString();
    ret += ':';
    ret += dt.year.toString();
    return ret;
  }

  static String getNewFileName() {
    DateTime dt = DateTime.now();
    String ret = '';
    ret += dt.day.toString();
    ret += dt.month.toString();
    ret += dt.year.toString();
    ret += '_';
    ret += dt.hour.toString();
    ret += dt.minute.toString();
    ret += dt.second.toString();
    ret += '_';
    return ret;
  }

  static void showErrorSnackBar(GlobalKey<ScaffoldState> globalKey,
      {String text = ''}) {
    final snackBar = ErrorSnackBar(text);
    globalKey.currentState.showSnackBar(snackBar);
  }

  static void showSuccessSnackBar(GlobalKey<ScaffoldState> globalKey,
      {String text = ''}) {
    final snackBar = SuccessSnackBar(text);
    globalKey.currentState.showSnackBar(snackBar);
  }

  static void deleteFile(String path) {
    File _img = File(path);
    _img.delete();
  }

  static double calculatePerMonth(double p, int t, double r) {
    return p + ((p * t * r) / 100);
  }

  static void checkIsHead() {
    isHead = loggedinAgent.role == 'head';
  }
}
