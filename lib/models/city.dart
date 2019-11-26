import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  String id;
  String name;

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    name = doc['name'];
  }

  @override
  String toString() {
    return "[" + id + ", " + name + "]";
  }
}
