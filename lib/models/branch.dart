import 'package:alhaji_user_app/models/products.dart';

class Branches {
  String sId;
  String name;
  String address;
  String pincode;
  bool isActive;
  String createdBy;
  String updatedBy;
  String branchCode;
  String createdDate;
  String modifiedDate;
  num totalQuantity;
  List<Product> addOns;

  Branches(
      {this.sId,
      this.name,
      this.address,
      this.pincode,
      this.isActive,
      this.createdBy,
      this.updatedBy,
      this.branchCode,
      this.createdDate,
      this.modifiedDate,
      this.totalQuantity,
      this.addOns});

  Branches.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    pincode = json['pincode'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    branchCode = json['branchCode'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    totalQuantity = json['totalQuantity'];
    if (json['addOns'] != null) {
      addOns = new List<Product>();
      json['addOns'].forEach((v) {
        addOns.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['branchCode'] = this.branchCode;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['totalQuantity'] = this.totalQuantity;
    if (this.addOns != null) {
      data['addOns'] = this.addOns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
