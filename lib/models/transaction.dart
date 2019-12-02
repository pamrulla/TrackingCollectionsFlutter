import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String id;
  String agent;
  String customer;
  int type;
  double amount;
  String date;

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
    date = doc['date'];
  }
}
