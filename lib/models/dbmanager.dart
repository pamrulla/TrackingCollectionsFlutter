import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as fpath;
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/basic_details.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';

class DBManager {
  final String cityCollection = 'City';
  final String agentCollection = 'Agent';
  final String basicDetailsCollection = 'BasicDetails';

  DBManager._privateConstructor();
  static DBManager instance = DBManager._privateConstructor();

  void getCitiesList() async {
    await Firestore.instance
        .collection(cityCollection)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        City city = City();
        city.fromDocument(doc);
        cities.add(city);
      });
      print(cities);
    });
  }

  Future<bool> addAgent(Agent agent) async {
    DocumentReference doc =
        await Firestore.instance.collection(agentCollection).add(agent.toMap());
    if (doc == null) {
      return false;
    } else {
      agent.id = doc.documentID;
      return true;
    }
  }

  Future<bool> updateBasicDetails(BasicDetails basicDetails) async {
    if (basicDetails.id != null && basicDetails.id.isNotEmpty) {
      return await addBasicDetails(basicDetails);
    } else {
      await Firestore.instance
          .collection(basicDetailsCollection)
          .document(basicDetails.id)
          .setData(basicDetails.toMap());
      return true;
    }
  }

  Future<String> uploadFileAndGetUrl(String path) async {
    String ext = fpath.extension(path);
    final String fileName =
        Utils.getNewFileName() + Random().nextInt(10000).toString() + ext;
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(path),
      StorageMetadata(
        contentType: 'image/jpeg',
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  Future<bool> addBasicDetails(BasicDetails basicDetails) async {
    if (basicDetails.id == null || basicDetails.id.isEmpty) {
      await updateBasicDetails(basicDetails);
      return true;
    } else {
      DocumentReference doc = await Firestore.instance
          .collection(basicDetailsCollection)
          .add(basicDetails.toMap());

      if (doc == null) {
        return false;
      } else {
        basicDetails.id = doc.documentID;
        return true;
      }
    }
  }
}
