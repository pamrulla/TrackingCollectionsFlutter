import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  String id;
  String name;
  String number;
  String city;
  int durationType;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'city': city,
      'durationType': durationType,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
    city = map['city'];
    durationType = map['durationType'];
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
    number = doc['number'];
    city = doc['city'];
    durationType = doc['durationType'];
  }
}
