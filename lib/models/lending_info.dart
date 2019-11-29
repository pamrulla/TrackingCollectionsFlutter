import 'package:cloud_firestore/cloud_firestore.dart';

class LendingInfo {
  String id;
  String customer;
  int durationType;
  String city;
  String date;
  double amount;
  int months;
  double interestRate;

  Map<String, dynamic> toMap() {
    return {
      'customer': customer,
      'durationType': durationType,
      'city': city,
      'date': date,
      'amount': amount,
      'months': months,
      'interestRate': interestRate,
    };
  }

  void fromDocument(DocumentSnapshot map) {
    id = map.documentID;
    customer = map['customer'];
    durationType = map['durationType'];
    city = map['city'];
    date = map['date'];
    amount = map['amount'];
    months = map['months'];
    interestRate = map['interestRate'];
  }
}
