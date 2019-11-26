import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_collections/models/agent.dart';
import 'package:tracking_collections/models/city.dart';
import 'package:tracking_collections/utils/constants.dart';

class DBManager {
  final String cityCollection = 'City';
  final String agentCollection = 'Agent';

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
}
