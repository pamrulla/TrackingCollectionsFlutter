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
}
