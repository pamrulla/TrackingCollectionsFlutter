import 'package:cloud_firestore/cloud_firestore.dart';

class Agent {
  String id = '';
  String name = '';
  String number = '';
  List<String> city = [];
  String userId = '';
  String role = '';
  bool isFirstTime = true;
  String head = '';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'city': city,
      'userId': userId,
      'role': role,
      'isFirstTime': isFirstTime,
      'head': head,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
    map['city'].forEach((e) {
      city.add(e);
    });
    userId = map['userId'];
    role = map['role'];
    isFirstTime = map['isFirstTime'];
    head = map['head'];
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
    number = doc['number'];
    doc['city'].forEach((e) {
      city.add(e);
    });
    userId = doc['userId'];
    role = doc['role'];
    isFirstTime = doc['isFirstTime'];
    head = doc['head'];
  }
}
