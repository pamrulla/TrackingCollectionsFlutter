import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String id = '';
  String agent = '';
  String customer = '';
  int type = 0;
  double amount = 0;
  DateTime date = DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'agent': agent,
      'customer': customer,
      'type': type,
      'amount': amount,
      'date': date,
    };
  }

  void fromDocument(DocumentSnapshot doc) {
    id = doc.documentID;
    agent = doc['agent'];
    customer = doc['customer'];
    type = doc['type'];
    amount = doc['amount'];
    date = doc['date'].toDate();
  }
}
