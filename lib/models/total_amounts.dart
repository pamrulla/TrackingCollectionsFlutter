import 'package:cloud_firestore/cloud_firestore.dart';

class TotalAmounts {
  String id = '';
  String customer = '';
  double totalRepaid = 0;
  double totalPenalty = 0;

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
    totalRepaid = double.tryParse(doc['totalRepaid'].toString());
    totalPenalty = double.tryParse(doc['totalPenalty'].toString());
  }
}
