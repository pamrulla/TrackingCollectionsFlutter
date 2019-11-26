class CustomerBasicDetails {
  int id;
  String photo;
  String name;
  String occupation;
  String fatherName;
  String adharNumber;
  String permanantAddress;
  String temporaryAddress;
}

class CustomerPhoneNumber {
  int id;
  int customer;
  String number;
}

class CustomerLendingInfo {
  int id;
  int customer;
  int durationType;
  int city;
  String date;
  double amount;
  int months;
  double interestRate;
}

class CustomerDocument {
  int id;
  int customer;
  String documentName;
  String documentProof;
}

class CustomerSecurity {
  int id;
  int security;
}

class Transaction {
  String date;
  double amount;
}
