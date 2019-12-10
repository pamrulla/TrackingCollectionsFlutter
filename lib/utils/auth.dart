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

  Future<bool> changePassword(String password) async {
    bool ret = true;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.updatePassword(password).catchError((e) {
      print('khan');
      print(e);
      ret = false;
    });
    if (ret) {
      currentAgent.isFirstTime = false;
      await DBManager.instance.updateAgent(currentAgent);
    }
    return ret;
  }
}
