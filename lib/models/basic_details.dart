import 'package:cloud_firestore/cloud_firestore.dart';

class BasicDetails {
  String id;
  String photo;
  String name;
  String occupation;
  String fatherName;
  String adharNumber;
  bool isSameAsPermanentAddress;
  String permanentAddress;
  String temporaryAddress;

  BasicDetails() {
    isSameAsPermanentAddress = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'photo': photo,
      'name': name,
      'occupation': occupation,
      'fatherName': fatherName,
      'adharNumber': adharNumber,
      'isSameAsPermanentAddress': isSameAsPermanentAddress,
      'permanentAddress': permanentAddress,
      'temporaryAddress': temporaryAddress,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photo = map['photo'];
    name = map['name'];
    occupation = map['occupation'];
    fatherName = map['fatherName'];
    adharNumber = map['adharNumber'];
    isSameAsPermanentAddress = map['isSameAsPermanentAddress'];
    permanentAddress = map['permanentAddress'];
    temporaryAddress = map['temporaryAddress'];
  }

  void fromDocument(DocumentSnapshot map) {
    id = map.documentID;
    photo = map['photo'];
    name = map['name'];
    occupation = map['occupation'];
    fatherName = map['fatherName'];
    adharNumber = map['adharNumber'];
    isSameAsPermanentAddress = map['isSameAsPermanentAddress'];
    permanentAddress = map['permanentAddress'];
    temporaryAddress = map['temporaryAddress'];
  }
}
