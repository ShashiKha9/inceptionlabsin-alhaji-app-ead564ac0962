import 'package:alhaji_user_app/models/branch.dart';

class ProductsList {
  List<Product> productsList;

  ProductsList({this.productsList});

  ProductsList.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      productsList = new List<Product>();
      json['result'].forEach((v) {
        productsList.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.productsList != null) {
      data['result'] = this.productsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String sId;
  String name;
  num price;
  String categoryCode;
  String shortDescription;
  String fullDescription;
  num weight;
  num energy;
  num protein;
  num fat;
  List<String> images;
  bool isActive;
  String createdDate;
  String createdBy;
  String productCode;
  String modifiedDate;
  String branchCode;
  num totalQuantity;
  List<Branches> branches;
  bool isTaxInclusive;

  Product({
    this.sId,
    this.name,
    this.price,
    this.categoryCode,
    this.shortDescription,
    this.fullDescription,
    this.weight,
    this.energy,
    this.protein,
    this.fat,
    this.images,
    this.isActive,
    this.createdDate,
    this.createdBy,
    this.productCode,
    this.modifiedDate,
    this.branchCode,
    this.totalQuantity,
    this.branches,
    this.isTaxInclusive,
  });

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    categoryCode = json['categoryCode'];
    shortDescription = json['shortDescription'];
    fullDescription = json['fullDescription'];
    weight = json['weight'];
    energy = json['energy'];
    protein = json['protein'];
    fat = json['fat'];
    if (json['branches'] != null) {
      images = json['images'].cast<String>();
    }
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    productCode = json['productCode'];
    modifiedDate = json['modifiedDate'];
    branchCode = json['branchCode'];
    totalQuantity = json['totalQuantity'];
    if (json['branches'] != null) {
      branches = new List<Branches>();
      json['branches'].forEach((v) {
        branches.add(new Branches.fromJson(v));
      });
    }
    isTaxInclusive = json['isTaxInclusive'] ?? false;
  }

  Map<String, dynamic> toJson({num totalQuantity}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['categoryCode'] = this.categoryCode;
    data['shortDescription'] = this.shortDescription;
    data['fullDescription'] = this.fullDescription;
    data['weight'] = this.weight;
    data['energy'] = this.energy;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['images'] = this.images;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['createdBy'] = this.createdBy;
    data['productCode'] = this.productCode;
    data['modifiedDate'] = this.modifiedDate;
    data['branchCode'] = this.branchCode;
    data['maxQuantity'] = this.totalQuantity;
    if (totalQuantity != null) {
      data['totalQuantity'] = totalQuantity;
    }
    if (this.branches != null) {
      data['branch'] = this.branches[0].toJson();
    }
    return data;
  }
}
