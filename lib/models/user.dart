class User {
  String sId;
  String userName;
  String firstName;
  String secondName;
  String emailId;
  List<PhoneNumbers> phoneNumbers;
  String pincode;
  int noOfOrder;
  bool isActive;
  String createdDate;
  String createdBy;
  String customerCode;
  String role;

  User(
      {this.sId,
      this.userName,
      this.firstName,
      this.secondName,
      this.emailId,
      this.phoneNumbers,
      this.pincode,
      this.noOfOrder,
      this.isActive,
      this.createdDate,
      this.createdBy,
      this.customerCode,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    userName = json['userName'] ?? '';
    firstName = json['firstName'] ?? '';
    secondName = json['secondName'] ?? '';
    emailId = json['emailId'] ?? '';
    if (json['phoneNumbers'] != null) {
      phoneNumbers = new List<PhoneNumbers>();
      json['phoneNumbers'].forEach((v) {
        phoneNumbers.add(new PhoneNumbers.fromJson(v));
      });
    }
    pincode = json['pincode'] ?? '';
    noOfOrder = json['noOfOrder'] ?? '';
    isActive = json['isActive'] ?? '';
    createdDate = json['createdDate'] ?? '';
    createdBy = json['createdBy'] ?? '';
    customerCode = json['customerCode'] ?? '';
    role = json['role'] ?? '';
  }

  Map<String, dynamic> toJson({bool edit = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['_id'] = this.sId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['secondName'] = this.secondName;
    data['emailId'] = this.emailId;
    if (this.phoneNumbers != null) {
      data['phoneNumbers'] = this.phoneNumbers.map((v) => v.toJson()).toList();
    }
    data['pincode'] = this.pincode;
    data['noOfOrder'] = this.noOfOrder ?? 0;
    data['isActive'] = this.isActive ?? true;
    data['createdDate'] = this.createdDate ?? DateTime.now().toIso8601String().substring(0, 19) + 'Z';
    data['createdBy'] = 'EMP002';
    if (edit) data['modifiedDate'] = DateTime.now().toIso8601String().substring(0, 19) + 'Z';
    if (edit) data['updatedBy'] = 'EMP002';
    if (edit) data['customerCode'] = this.customerCode;
    return data;
  }
}

class Result {
  List<User> result;
  Result({this.result});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<User>();
      json['result'].forEach((v) {
        result.add(new User.fromJson(v));
      });
    }
  }
}

class PhoneNumbers {
  String code;
  String phoneNumber;
  bool isPrimary;

  PhoneNumbers({this.code, this.phoneNumber, this.isPrimary});

  PhoneNumbers.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = "44";
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = true;
    return data;
  }
}
