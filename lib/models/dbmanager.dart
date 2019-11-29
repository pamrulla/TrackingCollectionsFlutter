import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as fpath;
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/basic_details.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/models/documents.dart';
import 'package:tracking_collections/models/lending_info.dart';
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/utils.dart';
import 'package:tracking_collections/viewmodels/CustomerBasicDetails.dart';
import 'package:tracking_collections/viewmodels/CustomerList.dart';

class DBManager {
  final String cityCollection = 'City';
  final String agentCollection = 'Agent';
  final String basicDetailsCollection = 'BasicDetails';
  final String lendingInfoCollection = 'LendingInfo';
  final String documentsCollection = 'Documents';

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
    print('Just Inside');
    DocumentReference doc =
        await Firestore.instance.collection(agentCollection).add(agent.toMap());
    print('Just Inside After');
    if (doc == null) {
      return false;
    } else {
      agent.id = doc.documentID;
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

  Future<bool> updateBasicDetails(BasicDetails basicDetails) async {
    if (basicDetails.id == null || basicDetails.id.isEmpty) {
      return await addBasicDetails(basicDetails);
    } else {
      await Firestore.instance
          .collection(basicDetailsCollection)
          .document(basicDetails.id)
          .setData(basicDetails.toMap());
      return true;
    }
  }

  Future<bool> addBasicDetails(BasicDetails basicDetails) async {
    if (basicDetails.id != null && basicDetails.id.isNotEmpty) {
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

  Future<bool> updateLendingInfo(LendingInfo data) async {
    if (data.id == null || data.id.isEmpty) {
      return await addLendingInfo(data);
    } else {
      await Firestore.instance
          .collection(lendingInfoCollection)
          .document(data.id)
          .setData(data.toMap());
      return true;
    }
  }

  Future<bool> addLendingInfo(LendingInfo data) async {
    if (data.id != null && data.id.isNotEmpty) {
      await updateLendingInfo(data);
      return true;
    } else {
      DocumentReference doc = await Firestore.instance
          .collection(lendingInfoCollection)
          .add(data.toMap());

      if (doc == null) {
        return false;
      } else {
        data.id = doc.documentID;
        return true;
      }
    }
  }

  Future<bool> updateDocuments(Documents data) async {
    if (data.id == null || data.id.isEmpty) {
      return await addDocuments(data);
    } else {
      await Firestore.instance
          .collection(documentsCollection)
          .document(data.id)
          .setData(data.toMap());
      return true;
    }
  }

  Future<bool> addDocuments(Documents data) async {
    if (data.id != null && data.id.isNotEmpty) {
      await updateDocuments(data);
      return true;
    } else {
      DocumentReference doc = await Firestore.instance
          .collection(documentsCollection)
          .add(data.toMap());

      if (doc == null) {
        return false;
      } else {
        data.id = doc.documentID;
        return true;
      }
    }
  }

  Future<List<CustomersList>> getCustomerList(DurationEnum type) async {
    List<CustomersList> items = [];
    QuerySnapshot docs = await Firestore.instance
        .collection(lendingInfoCollection)
        .where('durationType', isEqualTo: DurationEnum.values.indexOf(type))
        .getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      prefix0.DocumentSnapshot doc = docs.documents[i];
      DocumentSnapshot ds = await Firestore.instance
          .collection(basicDetailsCollection)
          .document(doc['customer'])
          .get();
      items.add(CustomersList(
        id: ds.documentID,
        penaltyAmount: 0.0,
        interestRate: doc['interestRate'],
        amount: doc['amount'],
        name: ds['name'],
      ));
    }
    return items;
  }

  Future<CustomerBasicDetails> getCustomerBasicDetails(String id) async {
    CustomerBasicDetails item = CustomerBasicDetails();
    DocumentSnapshot bd = await Firestore.instance
        .collection(basicDetailsCollection)
        .document(id)
        .get();
    if (bd == null) {
      return null;
    }
    item.basicDetails.fromDocument(bd);
    QuerySnapshot li = await Firestore.instance
        .collection(lendingInfoCollection)
        .where('customer', isEqualTo: id)
        .getDocuments();
    if (li == null || li.documents.length > 1) {
      return null;
    }
    item.lendingInfo.fromDocument(li.documents[0]);
    QuerySnapshot dc = await Firestore.instance
        .collection(documentsCollection)
        .where('customer', isEqualTo: id)
        .getDocuments();
    if (dc == null || dc.documents.length > 1) {
      return null;
    }
    item.documents.fromDocument(dc.documents[0]);

    return item;
  }
}
