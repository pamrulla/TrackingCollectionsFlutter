import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  String id;
  String name;
  String number;
  String city;
  int durationType;
  String userId;
  String role;
  bool isFirstTime = true;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'city': city,
      'durationType': durationType,
      'userId': userId,
      'role': role,
      'isFirstTime': isFirstTime,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
    city = map['city'];
    durationType = map['durationType'];
    userId = map['userId'];
    role = map['role'];
    isFirstTime = map['isFirstTime'];
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
    number = doc['number'];
    city = doc['city'];
    durationType = doc['durationType'];
    userId = doc['userId'];
    role = doc['role'];
    isFirstTime = doc['isFirstTime'];
  }
}
