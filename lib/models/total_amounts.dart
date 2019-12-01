import 'package:cloud_firestore/cloud_firestore.dart';

class TotalAmounts {
  String id;
  String customer;
  double totalRepaid;
  double totalPenalty;

  Map<String, dynamic> toMap() {
    return {
      'customer': customer,
      'totalRepaid': totalRepaid,
      'totalPenalty': totalPenalty,
    };
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    customer = doc['customer'];
    totalRepaid = doc['totalRepaid'];
    totalPenalty = doc['totalPenalty'];
  }
}
