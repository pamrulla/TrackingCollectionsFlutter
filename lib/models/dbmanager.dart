import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as fpath;
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/basic_details.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/models/documents.dart';
import 'package:tracking_collections/models/lending_info.dart';
import 'package:tracking_collections/models/total_amounts.dart';
import 'package:tracking_collections/models/transaction.dart' as my_transaction;
import 'package:tracking_collections/utils/constants.dart';
import 'package:tracking_collections/utils/globals.dart';
import 'package:tracking_collections/utils/utils.dart';
import 'package:tracking_collections/viewmodels/CustomerBasicDetails.dart';
import 'package:tracking_collections/viewmodels/CustomerList.dart';
import 'package:tracking_collections/viewmodels/TransactionDetails.dart';

class DBManager {
  final String cityCollection = 'City';
  final String agentCollection = 'Agent';
  final String basicDetailsCollection = 'BasicDetails';
  final String lendingInfoCollection = 'LendingInfo';
  final String documentsCollection = 'Documents';
  final String transactionsCollection = 'Transactions';
  final String totalAmountsCollection = 'TotalAmounts';

  DBManager._privateConstructor();

  static DBManager instance = DBManager._privateConstructor();

  Future<void> getCitiesList() async {
    cities.clear();
    QuerySnapshot docs =
        await Firestore.instance.collection(cityCollection).getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      City city = City();
      city.fromDocument(docs.documents[i]);
      cities.add(city);
    }
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

  Future<Agent> getAgentInfoFromUserId(String userId) async {
    Agent agent = Agent();
    QuerySnapshot docs = await Firestore.instance
        .collection(agentCollection)
        .where('userId', isEqualTo: userId)
        .getDocuments();
    if (docs.documents.length != 1) {
      return null;
    }
    agent.fromDocument(docs.documents[0]);
    return agent;
  }

  Future<Agent> getAgentInfo(String id) async {
    Agent agent = Agent();
    DocumentSnapshot doc =
        await Firestore.instance.collection(agentCollection).document(id).get();
    agent.fromDocument(doc);
    return agent;
  }

  Future<bool> updateAgent(Agent agent) async {
    await Firestore.instance
        .collection(agentCollection)
        .document(agent.id)
        .setData(agent.toMap())
        .catchError((e) {
      return false;
    });
    return true;
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

  Future<List<CustomersList>> getCustomerList(
      String agent, DurationEnum duration, String city) async {
    List<CustomersList> items = [];
    QuerySnapshot docs = await Firestore.instance
        .collection(lendingInfoCollection)
        .where('agent', isEqualTo: agent)
        .where('durationType', isEqualTo: duration.index)
        .where('city', isEqualTo: city)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; ++i) {
      DocumentSnapshot doc = docs.documents[i];
      DocumentSnapshot ds = await Firestore.instance
          .collection(basicDetailsCollection)
          .document(doc['customer'])
          .get();
      CustomersList cl = CustomersList(
        id: ds.documentID,
        interestRate: doc['interestRate'],
        durationType: doc['durationType'],
        amount: double.tryParse(doc['amount'].toString()),
        name: ds['name'],
      );
      items.add(cl);
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

  Future<List<CustomerBasicDetails>> getSecurityDetails(String id) async {
    List<CustomerBasicDetails> items = [];
    QuerySnapshot bd = await Firestore.instance
        .collection(basicDetailsCollection)
        .where('customer', isEqualTo: id)
        .getDocuments();
    if (bd == null || bd.documents.length == 0) {
      return null;
    }
    for (int i = 0; i < bd.documents.length; ++i) {
      DocumentSnapshot ds = bd.documents[i];
      CustomerBasicDetails cbd = CustomerBasicDetails();
      cbd.basicDetails.fromDocument(ds);
      QuerySnapshot dc = await Firestore.instance
          .collection(documentsCollection)
          .where('customer', isEqualTo: ds.documentID)
          .getDocuments();
      if (dc == null || dc.documents.length > 1) {
        return null;
      }
      cbd.documents.fromDocument(dc.documents[0]);
      items.add(cbd);
    }

    return items;
  }

  Future<bool> addTransaction(my_transaction.Transaction data) async {
    if (data.id != null && data.id.isNotEmpty) {
      //await updateDocuments(data);
      return true;
    } else {
      DocumentReference doc = await Firestore.instance
          .collection(transactionsCollection)
          .add(data.toMap());

      if (doc == null) {
        return false;
      } else {
        data.id = doc.documentID;
        return await updateTotalAmount(data);
      }
    }
  }

  Future<bool> updateTotalAmount(my_transaction.Transaction data) async {
    QuerySnapshot docs = await Firestore.instance
        .collection(totalAmountsCollection)
        .where('customer', isEqualTo: data.customer)
        .getDocuments();
    if (docs.documents.length == 0) {
      //Add New
      TotalAmounts ta = TotalAmounts();
      ta.customer = data.customer;
      ta.totalPenalty = data.type == 0 ? 0 : data.amount;
      ta.totalRepaid = data.type == 0 ? data.amount : 0;
      DocumentReference doc = await Firestore.instance
          .collection(totalAmountsCollection)
          .add(ta.toMap());

      if (doc == null) {
        return false;
      } else {
        ta.id = doc.documentID;
        return true;
      }
    } else {
      //Update Existing
      TotalAmounts ti = TotalAmounts();
      ti.fromDocument(docs.documents[0]);
      if (data.type == 0) {
        ti.totalRepaid += data.amount;
      } else {
        ti.totalPenalty += data.amount;
      }
      await Firestore.instance
          .collection(totalAmountsCollection)
          .document(ti.id)
          .setData(ti.toMap());
      return true;
    }
  }

  Future<TransactionDetails> getTransactionDetails(String id) async {
    TransactionDetails items = TransactionDetails();
    QuerySnapshot docs = await Firestore.instance
        .collection(transactionsCollection)
        .where('customer', isEqualTo: id)
        .orderBy('date')
        .getDocuments();
    if (docs.documents.length == 0) {
      return items;
    }
    for (int i = 0; i < docs.documents.length; ++i) {
      my_transaction.Transaction t = my_transaction.Transaction();
      t.fromDocument(docs.documents[i]);
      items.transaction.add(t);
    }
    QuerySnapshot docs1 = await Firestore.instance
        .collection(totalAmountsCollection)
        .where('customer', isEqualTo: id)
        .getDocuments();
    if (docs1.documents.length == 0) {
      //Add New
      items.totalAmounts.totalPenalty = 0;
      items.totalAmounts.totalRepaid = 0;
    } else {
      items.totalAmounts.fromDocument(docs1.documents[0]);
    }
    return items;
  }

  Future<List<Agent>> getAgentsList() async {
    List<Agent> items = [];
    QuerySnapshot docs = await Firestore.instance
        .collection(agentCollection)
        .where('head', isEqualTo: loggedinAgent.id)
        .getDocuments();
    if (docs.documents.length == 0) {
      return items;
    }
    for (int i = 0; i < docs.documents.length; ++i) {
      Agent a = Agent();
      a.fromDocument(docs.documents[i]);
      items.add(a);
    }
    return items;
  }

  Future<bool> performAddCustomer(
      BasicDetails basicDetails,
      LendingInfo lendingInfo,
      Documents documents,
      List<BasicDetails> securities,
      List<Documents> securitiesDocs) async {
    bool ret = true;

    WriteBatch batch = Firestore.instance.batch();

    DocumentReference bd =
        Firestore.instance.collection(basicDetailsCollection).document();
    batch.setData(bd, basicDetails.toMap());

    lendingInfo.customer = bd.documentID;
    DocumentReference li =
        Firestore.instance.collection(lendingInfoCollection).document();
    batch.setData(li, lendingInfo.toMap());

    documents.customer = bd.documentID;
    DocumentReference dd =
        Firestore.instance.collection(documentsCollection).document();
    batch.setData(dd, documents.toMap());

    for (int i = 0; i < securities.length; ++i) {
      securities[i].customer = bd.documentID;
      DocumentReference sd =
          Firestore.instance.collection(basicDetailsCollection).document();
      batch.setData(sd, securities[i].toMap());

      securitiesDocs[i].customer = sd.documentID;
      DocumentReference sdd =
          Firestore.instance.collection(documentsCollection).document();
      batch.setData(sdd, securitiesDocs[i].toMap());
    }

    await batch.commit().catchError((e) {
      ret = false;
    });

    return ret;
  }

  Future<bool> performUpdateCustomer(
      BasicDetails basicDetails,
      LendingInfo lendingInfo,
      Documents documents,
      List<BasicDetails> securities,
      List<Documents> securitiesDocs) async {
    bool ret = true;

    WriteBatch batch = Firestore.instance.batch();

    DocumentReference bd = Firestore.instance
        .collection(basicDetailsCollection)
        .document(basicDetails.id);
    batch.updateData(bd, basicDetails.toMap());

    DocumentReference li = Firestore.instance
        .collection(lendingInfoCollection)
        .document(lendingInfo.id);
    batch.updateData(li, lendingInfo.toMap());

    DocumentReference dd = Firestore.instance
        .collection(documentsCollection)
        .document(documents.id);
    batch.setData(dd, documents.toMap());

    for (int i = 0; i < securities.length; ++i) {
      if (securities[i].id.isEmpty) {
        securities[i].customer = bd.documentID;
        DocumentReference sd =
            Firestore.instance.collection(basicDetailsCollection).document();
        batch.setData(sd, securities[i].toMap());

        securitiesDocs[i].customer = sd.documentID;
        DocumentReference sdd =
            Firestore.instance.collection(documentsCollection).document();
        batch.setData(sdd, securitiesDocs[i].toMap());
      } else {
        DocumentReference sd = Firestore.instance
            .collection(basicDetailsCollection)
            .document(securities[i].id);
        batch.updateData(sd, securities[i].toMap());

        DocumentReference sdd = Firestore.instance
            .collection(documentsCollection)
            .document(securitiesDocs[i].id);
        batch.updateData(sdd, securitiesDocs[i].toMap());
      }
    }

    await batch.commit().catchError((e) {
      ret = false;
    });

    return ret;
  }

  Future<List<Agent>> getAgentsListForRemoveAgent(String agent, String city,
      {bool isChangeAgent = false}) async {
    List<Agent> items = [];
    QuerySnapshot docs = await Firestore.instance
        .collection(agentCollection)
        .where('head', isEqualTo: loggedinAgent.id)
        .where('city', arrayContains: city)
        .getDocuments();
    if (docs.documents.length == 0) {
      return items;
    }
    if (isChangeAgent == false) {
      items.add(loggedinAgent);
    }
    for (int i = 0; i < docs.documents.length; ++i) {
      if (docs.documents[i].documentID == agent) {
        continue;
      }
      Agent a = Agent();
      a.fromDocument(docs.documents[i]);
      items.add(a);
    }
    return items;
  }

  Future<bool> removeAgent(
      String currentAgent, String city, String newAgent) async {
    bool ret = true;
    QuerySnapshot docs = await Firestore.instance
        .collection(lendingInfoCollection)
        .where('agent', isEqualTo: currentAgent)
        .where('city', isEqualTo: city)
        .getDocuments();
    DocumentReference agentDoc =
        Firestore.instance.collection(agentCollection).document(currentAgent);

    await Firestore.instance.runTransaction((transaction) async {
      List<DocumentSnapshot> ds = [];
      //Reads
      for (int i = 0; i < docs.documents.length; ++i) {
        ds.add(await transaction.get(docs.documents[i].reference));
      }
      DocumentSnapshot as = await transaction.get(agentDoc);

      //Writes
      for (int i = 0; i < ds.length; ++i) {
        ds[i].data['agent'] = newAgent;
        await transaction.update(docs.documents[i].reference, ds[i].data);
      }
      Agent ag = Agent();
      ag.fromDocument(as);
      ag.city.remove(city);
      if (ag.city.length == 0) {
        await transaction.delete(agentDoc);
      } else {
        await transaction.update(agentDoc, ag.toMap());
      }
    }).catchError((e) {
      ret = false;
      print(e);
    });
    return ret;
  }

  Future<String> addNewCity(String cityName) async {
    bool ret = true;
    WriteBatch batch = Firestore.instance.batch();
    City city = City();
    city.name = cityName;
    DocumentReference dr =
        Firestore.instance.collection(cityCollection).document();
    batch.setData(dr, city.toMap());
    loggedinAgent.city.add(dr.documentID);
    DocumentReference ar = Firestore.instance
        .collection(agentCollection)
        .document(loggedinAgent.id);
    batch.updateData(ar, loggedinAgent.toMap());

    batch.commit().catchError((e) {
      ret = false;
    });

    if (ret) {
      await getCitiesList();
      return dr.documentID;
    }
    loggedinAgent.city.removeLast();
    return '';
  }

  Future<bool> transferCustomer(String customerId, String agentid) async {
    bool ret = true;
    DocumentSnapshot ds = await Firestore.instance
        .collection(lendingInfoCollection)
        .document(customerId)
        .get()
        .catchError((e) {
      ret = false;
    });
    if (ret) {
      LendingInfo li = LendingInfo();
      li.fromDocument(ds);
      li.agent = agentid;
      await Firestore.instance
          .collection(lendingInfoCollection)
          .document(customerId)
          .updateData(li.toMap())
          .catchError((e) {
        ret = false;
      });
    }
    return ret;
  }
}
