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
}
