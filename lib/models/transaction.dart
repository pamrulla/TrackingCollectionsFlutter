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
}
