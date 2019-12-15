import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
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
    loggedinAgent =
        await DBManager.instance.getAgentInfoFromUserId(result.user.uid);
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
      ret = false;
    });
    if (ret) {
      loggedinAgent.isFirstTime = false;
      await DBManager.instance.updateAgent(loggedinAgent);
    }
    return ret;
  }

  Future<List<String>> createAgentLogin(String name) async {
    List<String> creds = [];
    bool isSucceeded = true;
    String newName = name.replaceAll(' ', '.');
    String password = randomNumeric(6);
    do {
      String userName = newName + userNameTail;
      isSucceeded = true;
      AuthResult res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userName, password: password)
          .catchError((e) {
        isSucceeded = false;
        newName += randomNumeric(1);
      });
      if (isSucceeded && res != null) {
        creds.add(newName);
        creds.add(password);
        creds.add(res.user.uid);
      }
    } while (!isSucceeded);
    return creds;
  }
}
