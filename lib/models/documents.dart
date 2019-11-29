import 'package:cloud_firestore/cloud_firestore.dart';

class Documents {
  String id;
  String customer;
  List<String> documentNames = [];
  List<String> documentProofs = [];

  Map<String, dynamic> toMap() {
    return {
      'customer': customer,
      'documentNames': documentNames,
      'documentProofs': documentProofs,
    };
  }

  void fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    customer = document['customer'];
    document['documentNames'].forEach((d) {
      documentNames.add(d);
    });
    document['documentProofs'].forEach((d) {
      documentProofs.add(d);
    });
  }
}
