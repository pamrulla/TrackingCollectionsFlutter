import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracking_collections/models/dbmanager.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';

class Authorization {
  Future<bool> logIn(String username, String password) async {
    username += userNameTail;
    AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: username, password: password)
        .catchError((e) {});
    if (result == null) {
      return false;
    }
    currentAgent = await DBManager.instance.getAgentInfo(result.user.uid);
    Utils.checkIsHead();
    return true;
  }

  Future<bool> logOut() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }
}
